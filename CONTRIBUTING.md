# Contributing

Thank you for helping make Plane self-hosting safer and easier.

## Development setup

Install OpenTofu, TFLint, Trivy, terraform-docs, and pre-commit. Then:

```bash
cp .env.example .env
chmod 600 .env
cp terraform.tfvars.example terraform.tfvars
pre-commit install
make init
make fmt-check validate test lint security
```

Unit tests use a mocked Hetzner provider and create no infrastructure. Acceptance testing that creates billable resources must be proposed and approved separately.

## Pull requests

- Open an issue before large public-API or architecture changes.
- Keep changes focused and update tests, examples, and documentation together.
- Use Conventional Commits, for example `feat: add optional IPv6-only mode` or `fix: preserve primary IP during replacement`.
- Explain replacement, downtime, cost, security, state, and migration effects in the pull request.
- Include a `BREAKING CHANGE:` footer for incompatible variables, outputs, state addresses, defaults, or upgrade behavior.
- Never include plan files, state, `.env`, `terraform.tfvars`, credentials, or production output.

Maintainers use release-please to produce changelogs, semantic tags, and GitHub releases. Terraform/OpenTofu Registry consumers depend on `vMAJOR.MINOR.PATCH` tags.
