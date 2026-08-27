# Changelog

All notable changes will be documented here. Releases follow [Semantic Versioning](https://semver.org/) and are automated with release-please.

## 0.1.0 (2026-08-27)


### Features

* add Plane on Hetzner OpenTofu module ([c2eaafe](https://github.com/tleers/terraform-hcloud-plane/commit/c2eaafe88459129fb13f1dea15f4d4c3e0a4d3ef))


### Bug Fixes

* grant release workflow pull request permissions ([353790e](https://github.com/tleers/terraform-hcloud-plane/commit/353790e1083d52e702294a7f1edf7b9e7a643412))

## [Unreleased]

### Added

- Initial Hetzner Cloud module for a release-pinned Plane Community Edition deployment.
- Secure cloud-init bootstrap, backups, deletion protection, restricted firewall, examples, tests, CI, security scanning, and contributor automation.

### Changed

- Default to the low-cost CAX11 profile with 2 GiB swap, while retaining CAX21 as the documented 8 GB scale-up profile.
- Pin the bootstrap to Plane Community Edition v1.4.2.
- Parse the required `.env` token file without executing it as shell code.
