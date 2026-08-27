# Plane on Hetzner Cloud

A secure-by-default Terraform/OpenTofu module for running [Plane Community Edition](https://github.com/makeplane/plane) on a small Hetzner Cloud server.

It provisions a static IPv4, restricted Cloud Firewall, protected Ubuntu server, Hetzner backups, and a release-pinned Plane Docker Compose stack. Service secrets are generated on the server instead of entering state.

> **Status:** pre-release. The module is validated locally but has not yet been acceptance-tested on a fresh Hetzner project. Review the plan and cost before applying.

## What you get

- One ARM64 or x86-64 Hetzner Cloud server; the low-cost `cax11` profile is the default
- Only ports 80/443 public; SSH restricted to operator-provided CIDRs
- Static primary IPv4 and free IPv6
- Hetzner backups and deletion/rebuild protection enabled by default
- Optional persistent swap file for memory-constrained small deployments
- Ubuntu 24.04, distribution-packaged Docker, and Plane CE pinned to `v1.4.2`
- Automatic TLS through Plane's Caddy-based proxy after DNS resolves
- Secrets generated on-host, never passed through module inputs or outputs
- Mocked tests, Terraform/OpenTofu CI, TFLint, Trivy, Dependabot, and automated semantic releases

This is a cost-conscious single-node deployment, not a highly available architecture. See [Architecture](docs/architecture.md) and [Security model](docs/security.md).

## Deployment profiles and cost

The default `cax11` profile provides 2 ARM vCPU, 4 GB RAM, 40 GB local disk, and a 2 GiB swap safety valve for a small team. The 8 GB `cax21` profile is the sensible next step if imports, background work, or simultaneous users cause memory pressure.

At Hetzner's Nuremberg list price checked on 2026-08-28, a `cax11` is €5.99/month plus a €0.50 primary IPv4. Enabling the default Hetzner backups adds 20% of server cost, for an indicative €7.69/month before VAT, a domain, SMTP, or off-server backup storage. Prices and taxes vary by account and location; always review the Hetzner estimate and `tofu plan` before applying.

## Prerequisites

- OpenTofu 1.8+ or a compatible Terraform version
- A Hetzner Cloud project and project-scoped read/write API token
- An Ed25519 SSH public key
- A hostname you control

## Quick start

Credentials always live in the gitignored `.env`; do not export or paste the token into commands:

```bash
cp .env.example .env
chmod 600 .env
# Edit .env and set HCLOUD_TOKEN.

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with the hostname, email, SSH public key, and SSH CIDRs.

make init
make plan
# Review plane.tfplan carefully.
make apply
```

Create the hostname's DNS `A` record using:

```bash
./scripts/tofu.sh output -raw ipv4_address
```

Follow first-boot progress with the command printed by:

```bash
./scripts/tofu.sh output -raw bootstrap_log_command
```

Once DNS resolves and bootstrap completes, open `./scripts/tofu.sh output -raw plane_url`, claim the instance-admin account, disable open signup and workspace creation in `/god-mode`, configure SMTP, and invite collaborators.

## Use as a module

Until the first public release, use a pinned Git source or a local checkout. After publication to the Terraform/OpenTofu Registry, the intended source address is `tleers/plane/hcloud`.

```hcl
module "plane" {
  source = "git::https://github.com/tleers/terraform-hcloud-plane.git?ref=v0.1.0"

  domain            = "plane.example.com"
  admin_email       = "ops@example.com"
  ssh_public_key    = file(pathexpand("~/.ssh/id_ed25519.pub"))
  ssh_allowed_cidrs = ["203.0.113.10/32"]
}
```

See the [basic](examples/basic/main.tf) and [complete](examples/complete/main.tf) examples and the [generated module reference](docs/module-reference.md).

## Credentials, configuration, and state

- `.env` contains `HCLOUD_TOKEN` and must be mode `0600`. `scripts/tofu.sh` loads it for every command and refuses missing/empty credentials.
- `terraform.tfvars` contains non-secret deployment configuration. It is ignored because real domains, emails, keys, and CIDRs are operationally sensitive.
- State and plans are ignored. Teams should configure an encrypted, locked remote backend outside this reusable module.
- Do not put SMTP, OAuth, database, or other application secrets into module variables. Configure Plane authentication in `/god-mode` after bootstrap.

## Operations and upgrades

Plane lives at `/opt/plane-selfhost` on the server. Changing `cloud-init.yaml.tftpl` or `plane_version` does **not** rerun bootstrap on an existing node. Upgrade Plane through its documented backup-and-upgrade flow; do not assume an infrastructure apply performs application migrations.

Deletion protection is enabled by default. Before intentional destruction, export and test an off-server backup, set `protect_server = false`, apply that change, and review a destroy plan. Full procedures are in the [deployment runbook](docs/deployment-runbook.md).

## Development

```bash
make fmt-check
make validate
make test
make lint
make security
make docs
```

Tests use a mocked provider and create no billable resources. A fresh-project acceptance deployment is the remaining release gate before calling this production-tested. See [Contributing](CONTRIBUTING.md) and [Security](SECURITY.md).

## License

MIT. Plane itself is licensed separately under AGPL-3.0; using this module does not change Plane's license.
