# Security policy

## Supported versions

Security fixes are provided for the latest major release. Upgrade guidance accompanies breaking releases.

## Report a vulnerability

Do not open a public issue. Use GitHub's **Security → Report a vulnerability** private reporting flow. Include affected versions, impact, reproduction steps, and any suggested remediation. Maintainers should acknowledge a report within five business days.

## Operator responsibilities

- Store `HCLOUD_TOKEN` only in the gitignored `.env` with mode `0600` or an equivalent CI secret store.
- Use project-scoped, least-privilege credentials and rotate them after exposure.
- Restrict SSH CIDRs, configure SMTP and invite-only signup, enable backups, export backups off-server, and keep Plane and the host patched.
- Review `tofu plan` before every apply. State may contain infrastructure metadata and must be encrypted and access-controlled.

The module avoids placing generated Plane service secrets in OpenTofu state. They are generated during bootstrap and stored as root-readable configuration on the server.
