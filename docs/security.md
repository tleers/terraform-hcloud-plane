# Security model

## Defaults

- SSH is accepted only from explicit CIDRs.
- HTTP and HTTPS are the only globally exposed TCP ports.
- Hetzner backups and delete/rebuild protection are enabled.
- Plane is release-pinned and debug mode is disabled.
- Database, queue, and object-storage services stay on the Compose network.
- Application secrets are generated on-host and `plane.env` is mode `0600`.

## Trust and supply chain

The deployment trusts Ubuntu repositories, the official Plane GitHub release assets, Plane's container images, Docker Hub base images referenced by Plane, the Hetzner API/provider, and the operator's DNS and SMTP providers. Plane release tags are pinned, but upstream currently does not publish one consolidated checksum/signature manifest for every consumed artifact and image. Review release provenance before upgrades.

CI actions are pinned to full commit SHAs. Dependabot proposes action and provider updates. Trivy scans Terraform and cloud-init configuration; TFLint enforces module conventions. Repository settings should also require reviews, passing checks, signed releases where possible, secret scanning, push protection, and private vulnerability reporting.

## Known limitations

- One node is one failure domain.
- Server backups are not a substitute for tested, off-server application backups.
- Cloud-init logs and the root-readable filesystem are sensitive operational surfaces.
- A public IPv4 address is used for compatibility; IPv6-only operation is not yet supported.
- DNS is intentionally outside the module because operators use different providers. Certificate issuance starts only after DNS points to the output address.
