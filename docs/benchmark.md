# Repository practice benchmark

Captured on 2026-07-28 using GitHub repository search. Stars are a discovery signal, not a quality guarantee.

## Method

Two cohorts were inspected:

1. Repositories pushed in the previous three months, sorted by stars, using `terraform-module`, `opentofu`, and `hetzner` topics plus HCL filtering.
2. Repositories created in the previous three months, sorted by stars, to surface newer CI and agent-oriented conventions.

The closest mature Hetzner modules were [hcloud-k8s/terraform-hcloud-kubernetes](https://github.com/hcloud-k8s/terraform-hcloud-kubernetes) (685 stars), [hcloud-talos/terraform-hcloud-talos](https://github.com/hcloud-talos/terraform-hcloud-talos) (349), and [identiops/terraform-hcloud-k3s](https://github.com/identiops/terraform-hcloud-k3s) (155). Mature module references included [terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) (4,988), [nozaq/terraform-aws-secure-baseline](https://github.com/nozaq/terraform-aws-secure-baseline) (1,199), and [terraform-aws-modules/terraform-aws-lambda](https://github.com/terraform-aws-modules/terraform-aws-lambda) (1,044).

New repositories with relevant patterns included [andrewferdinandus/terraform-azure-aks](https://github.com/andrewferdinandus/terraform-azure-aks) (46 stars), [mkdev-me/terraform-aws-github-runner-lambda-microvms](https://github.com/mkdev-me/terraform-aws-github-runner-lambda-microvms) (26), and [Pratik-Nawale/terraform-for-aws](https://github.com/Pratik-Nawale/terraform-for-aws) (9). Higher-starred new HCL repositories were mostly courses rather than reusable modules and were weighted accordingly.

## Practices adopted

| Practice | Evidence in benchmark | This repository |
|---|---|---|
| Registry-compatible root module | Mature `terraform-*-modules` repositories | Root `*.tf` files and semantic tags |
| Executable examples and tests | EKS/Lambda examples and test fixtures | `examples/` plus mocked native tests |
| Format, init, validate CI | All mature modules | Terraform and OpenTofu matrix |
| Security-as-code | hcloud-talos Checkov; newer DevSecOps repos | Trivy SARIF and dependency review |
| Generated reference docs | secure-baseline and pre-commit ecosystems | terraform-docs configuration |
| Automated releases | semantic-release/release-please in leading modules | release-please and changelog |
| Automated dependency updates | Renovate/Dependabot common across active repos | Dependabot for Actions and Terraform |
| Least-privilege CI | Current hcloud-talos workflows | read-only defaults, scoped write release job |
| Supply-chain pinning | Newer hcloud-talos workflow actions pinned by SHA | Full action commit SHAs |
| Contributor templates | Mature modules | contribution, security, support, issue/PR templates |
| Agent guidance | hcloud-talos `CLAUDE.md`; newer agentic IaC repositories | scoped `AGENTS.md` and repo-local skill |

## Deliberate differences

This repository avoids `pull_request_target` for code validation because it increases risk when running fork-authored changes. CI never applies infrastructure and does not receive `HCLOUD_TOKEN`. It also avoids a large Terragrunt wrapper: a single deployment module does not yet need orchestration, and consumers can call it from Terragrunt without changes.
