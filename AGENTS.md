# Agent guide

This repository provisions a public, billable Plane deployment. Treat plans as review artifacts and applies as production changes.

## Scope

- Keep the root directory usable as a Terraform/OpenTofu Registry module.
- Keep operational documentation in `docs/`, runnable examples in `examples/`, tests in `tests/`, and helper commands in `scripts/`.
- Do not move module files out of the repository root.
- Prefer OpenTofu commands in documentation while maintaining Terraform compatibility.

## Safe workflow

1. Read `README.md`, `SECURITY.md`, and the files affected by the change.
2. Never print, commit, request in chat, or place secrets in `terraform.tfvars`. Credentials belong in the gitignored `.env`; ask the operator to populate it.
3. Run `make fmt-check`, `make validate`, `make test`, `make lint`, and `make security` when their tools are available.
4. Do not run `apply`, `destroy`, import, state mutation, or remote provisioner commands without explicit user authorization.
5. For any destructive request, resolve the exact workspace and resources, require a current off-server backup, and show the plan first.
6. Update examples, generated module docs, changelog/release notes, and migration guidance when the public interface changes.

## Design constraints

- OpenTofu owns Hetzner infrastructure; Plane's release Compose bundle owns application services.
- Pin Plane releases and provider constraints. Do not deploy `latest` application tags.
- Generate service secrets on the server so they do not enter state or cloud-init input.
- Keep SSH restricted, backups and deletion protection enabled, and only ports 80/443 public by default.
- Changing cloud-init does not update an existing server. Document an explicit operational migration instead of implying it will.
- Never encode a private key, Hetzner token, SMTP password, OAuth secret, or generated `plane.env` in state or outputs.

## Public API

Variables and outputs are compatibility commitments. Additive optional variables are minor changes; removing or renaming inputs/outputs, changing defaults with operational impact, or forcing resource replacement is breaking. Use Conventional Commits and mark breaking changes explicitly.
