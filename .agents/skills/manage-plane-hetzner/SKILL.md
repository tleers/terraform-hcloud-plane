---
name: manage-plane-hetzner
description: Safely develop, validate, deploy, upgrade, troubleshoot, or operate the repository's Plane Community Edition module on Hetzner Cloud. Use for changes to OpenTofu/Terraform, cloud-init, Docker Compose bootstrap, Hetzner networking/firewalls, Plane upgrades/backups/authentication, module releases, or production plans in this repository.
---

# Manage Plane on Hetzner

Work from the repository root. Read `AGENTS.md` first, then read the relevant architecture, security, or runbook document.

## Choose the workflow

- For module changes, inspect variables, outputs, examples, and tests together. Preserve the Registry-compatible root layout.
- For bootstrap changes, distinguish first-boot behavior from updates to an existing server. Never imply cloud-init reruns automatically.
- For upgrades, require an exported off-server backup and use Plane's application upgrade flow.
- For plan/apply work, require `.env` with mode `0600`. Ask the operator to populate it; never request a token in chat or recommend one-off `export HCLOUD_TOKEN=...` commands.
- For authentication, configure SMTP and invite-only access through Plane God mode after deployment. Keep credentials outside module inputs and state.

## Validate changes

Run the applicable checks:

```bash
make fmt-check
make validate
make test
make lint
make security
make docs
```

Mocked tests are safe and non-billable. Do not run acceptance tests, apply, destroy, imports, state mutations, or remote commands without explicit authorization.

## Review operational impact

Before presenting a change, identify:

- resource replacement or state migration;
- downtime and data migration;
- monthly cost change;
- public network or credential exposure;
- Plane version and backup compatibility;
- changes to variables, outputs, examples, generated docs, and release semantics.

Treat variable/output removals, impactful default changes, state-address changes, and forced replacements as breaking changes. Document migration steps and use a Conventional Commit with a `BREAKING CHANGE:` footer.

## Handle destructive operations

Resolve the exact project, state, and resources. Require a recent off-server backup and a reviewed plan. To destroy the protected server, first set `protect_server = false` and apply that change; never bypass protection out of convenience.
