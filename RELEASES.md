# Release History & Versioning Policy — Offlink

This document tracks all official releases of Offlink, describes the release classification tiers, and explains the semantic versioning scheme used for distribution.

---

## Release Channels & Stability Tiers

Offlink utilizes three progressive release channels to balance rapid iteration with operational stability:

| Channel | Identifier | Stability & Testing | Target Audience |
| :--- | :--- | :--- | :--- |
| **Alpha (Pre-Release)** | `alpha.x` | Architecture complete, CI verified, actively evolving APIs. | Developers, security researchers, early testers. |
| **Beta (Pre-Release)** | `beta.x` | Feature-complete, stabilized APIs, multi-device field testing. | Community testers and power users. |
| **Stable (General Availability)** | `vX.Y.Z` | Production signed, thoroughly audited, F-Droid approved. | General end users and production deployments. |

---

## Release History

| Version | Release Date | Channel | Git Tag | Target SDK | Min SDK | SHA-256 Checksum | Release Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **v0.1.0-alpha.1** | 2026-11-23 | Alpha | [`v0.1.0-alpha.1`](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.1) | API 36 | API 24 | `e10a26c0fdc8...` | [Notes](CHANGELOG.md#010-alpha1---2026-11-23) |

---

## Versioning Scheme

Offlink adheres to [Semantic Versioning 2.0.0](https://semver.org/):

$$\text{MAJOR}.\text{MINOR}.\text{PATCH}[-\text{PRERELEASE}][+\text{BUILD}]$$

- **MAJOR**: Incremented for breaking protocol changes incompatible with previous mesh routing topologies.
- **MINOR**: Incremented for new functional capabilities, UI modules, or protocol additions that remain backward-compatible.
- **PATCH**: Incremented for backward-compatible bug fixes, security patches, or battery optimizations.
- **PRERELEASE**: Labeled as `-alpha.<n>` or `-beta.<n>` during pre-production cycles.
- **BUILD**: Numeric build code corresponding to Android's `versionCode`.

---

## Forward Compatibility & Upgrades

1. **Protocol Upgrades**: The Offlink packet protocol includes version negotiation headers (`version: 1`). New packet types ignore unknown types or route them as opaque payloads to prevent network partition.
2. **Database Migrations**: Drift (SQLite) database schema migrations are managed systematically (currently at Schema Version 4) with automated unit and regression test coverage.
3. **Signing Keystore Policy**:
   - `v0.1.0-alpha.1` uses a development/test signing certificate.
   - Future stable releases will use the official air-gapped production signing identity. A manual reinstall will be required when upgrading across this boundary.
