#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
env_file="$repo_dir/.env"

if [[ ! -f "$env_file" ]]; then
  echo "Missing $env_file. Copy .env.example to .env and add HCLOUD_TOKEN." >&2
  exit 1
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  permissions=$(stat -f '%Lp' "$env_file")
else
  permissions=$(stat -c '%a' "$env_file")
fi

if [[ "$permissions" != "600" ]]; then
  echo "Refusing to load $env_file with permissions $permissions; run: chmod 600 .env" >&2
  exit 1
fi

HCLOUD_TOKEN=$(python3 - "$env_file" <<'PY'
import pathlib
import re
import sys

env_path = pathlib.Path(sys.argv[1])
token = None

for line_number, raw_line in enumerate(env_path.read_text(encoding="utf-8").splitlines(), start=1):
    line = raw_line.strip()
    if not line or line.startswith("#"):
        continue
    match = re.fullmatch(r"HCLOUD_TOKEN=(.*)", line)
    if not match:
        continue
    if token is not None:
        raise SystemExit(f"{env_path}: HCLOUD_TOKEN is defined more than once")
    value = match.group(1).strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
        value = value[1:-1]
    if not value:
        raise SystemExit(f"{env_path}:{line_number}: HCLOUD_TOKEN is empty")
    token = value

if token is None:
    raise SystemExit(f"{env_path}: HCLOUD_TOKEN is missing")

print(token, end="")
PY
)

if [[ -z "$HCLOUD_TOKEN" ]]; then
  echo "HCLOUD_TOKEN is empty in $env_file." >&2
  exit 1
fi

if ! command -v tofu >/dev/null 2>&1; then
  echo "OpenTofu is not installed or not on PATH." >&2
  exit 1
fi

cd "$repo_dir"
exec env HCLOUD_TOKEN="$HCLOUD_TOKEN" tofu "$@"
