# Show HN submission draft

## Title

Show HN: Plane on Hetzner — a small, secure-by-default OpenTofu module

## Submission text

I wanted a self-hosted Plane deployment that was easier to reason about than a pile of copied Compose commands, without turning a two-person team's project tracker into a Kubernetes project.

This repository provisions one Hetzner Cloud server for Plane Community Edition with OpenTofu or Terraform. It creates the primary IPv4, firewall, protected server, and first-boot bootstrap; Plane itself remains its upstream, pinned Compose bundle. Plane secrets are generated on the server so they do not become Terraform variables, outputs, or state.

The default profile is a CAX11 (2 ARM vCPU, 4 GB RAM, 40 GB disk) with a small swap safety valve. At the Nuremberg list price I checked this week it is roughly €7.69/month before VAT, domain, SMTP, and off-server backup storage, including the default server-backup surcharge. CAX21 is the documented 8 GB scale-up profile.

It includes mocked OpenTofu tests, Terraform/OpenTofu CI, TFLint, Trivy, generated module docs, Dependabot, release-please, a contribution/security policy, and an agent guide that explicitly refuses unreviewed billable applies. A `.env` wrapper reads `HCLOUD_TOKEN` without sourcing or executing the file.

The initial release is deliberately marked pre-release until a clean Hetzner-project acceptance deployment completes. I would especially value review of the cloud-init/bootstrap boundary, the small-node resource profile, recovery procedure, and whether the module should own DNS integrations or keep DNS provider-neutral.

Repository: https://github.com/tleers/terraform-hcloud-plane

## First comment

The module is not the same topology as my current shared production host: this one intentionally creates a dedicated Plane server and owns only those resources. It does not import, replace, or destroy an existing shared server.

The main trade-off is intentional. It does not model Plane's application services as individual Terraform resources. The module owns Hetzner infrastructure; the pinned upstream Compose release owns Plane. That keeps routine Plane upgrades recognizable and avoids maintaining a divergent Compose specification.
