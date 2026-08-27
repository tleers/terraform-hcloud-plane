# Changelog

All notable changes will be documented here. Releases follow [Semantic Versioning](https://semver.org/) and are automated with release-please.

## [Unreleased]

### Added

- Initial Hetzner Cloud module for a release-pinned Plane Community Edition deployment.
- Secure cloud-init bootstrap, backups, deletion protection, restricted firewall, examples, tests, CI, security scanning, and contributor automation.

### Changed

- Default to the low-cost CAX11 profile with 2 GiB swap, while retaining CAX21 as the documented 8 GB scale-up profile.
- Pin the bootstrap to Plane Community Edition v1.4.2.
- Parse the required `.env` token file without executing it as shell code.
