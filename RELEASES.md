# Release History & Versioning Scheme — Offlink

This document tracks official releases of Offlink, outlines our stability classification tiers, and documents the versioning scheme used for Android distribution.

> [!NOTE]
> For downloadable APK binaries, checksum manifests (`SHA256SUMS.txt`), and commit links, visit the **[Official GitHub Releases Page](https://github.com/Omkar-git-hub/offlink-releases/releases)**.

---

## Release Channels & Stability Tiers

Offlink utilizes three progressive release tiers:

| Channel | Identifier | Stability & Testing Stage | Target Audience |
| :--- | :--- | :--- | :--- |
| **Alpha (Pre-Release)** | `alpha.x` | Architecture complete, CI verified, rapid protocol iteration. | Developers, security researchers, early testers. |
| **Beta (Pre-Release)** | `beta.x` | Feature-complete, stabilized APIs, multi-device field testing. | Community testers and power users. |
| **Stable (General Availability)** | `vX.Y.Z` | Production signed, thoroughly audited, F-Droid approved. | General end users and production deployments. |

---

## Published Releases

| Version | Release Date | Channel | Git Tag | Target SDK | Min SDK | SHA-256 Checksum (APK) | Release Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **v0.1.0-alpha.5** | 2026-11-24 | Alpha | [`v0.1.0-alpha.5`](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.5) | API 36 | API 24 | `3608c6a2f754...` | [Notes](CHANGELOG.md#010-alpha5) |
| **v0.1.0-alpha.4** | 2026-11-23 | Alpha | [`v0.1.0-alpha.4`](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.4) | API 36 | API 24 | `d463d567764b...` | [Notes](CHANGELOG.md#010-alpha4---2026-11-23) |
| **v0.1.0-alpha.1** | 2026-11-23 | Alpha | [`v0.1.0-alpha.1`](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.1) | API 36 | API 24 | `e10a26c0fdc8...` | [Notes](CHANGELOG.md#010-alpha1---2026-11-23) |

---

## Semantic Versioning Scheme

Offlink strictly adheres to [Semantic Versioning 2.0.0](https://semver.org/):

$$\text{v}\text{MAJOR}.\text{MINOR}.\text{PATCH}[-\text{PRERELEASE}]$$

- **MAJOR**: Incremented for breaking protocol changes incompatible with previous mesh routing topologies.
- **MINOR**: Incremented for new functional capabilities, UI modules, or backward-compatible protocol features.
- **PATCH**: Incremented for backward-compatible bug fixes, security patches, or battery optimizations.
- **PRERELEASE**: Labeled as `-alpha.<n>` or `-beta.<n>` during pre-production cycles.
- **BUILD**: Numeric build code corresponding to Android's `versionCode`.

---

## Upgrade Compatibility & Signing Transitions

1. **Protocol Upgrades**: The Offlink packet protocol includes version negotiation headers (`version: 1`). New packet types ignore unknown types or route them as opaque payloads to prevent network partition.
2. **Database Migrations**: Drift (SQLite) database schema migrations are managed systematically with automated unit and regression test coverage.
3. **Signing Keystore Policy**:
   - Alpha testing builds use a developer testing certificate.
   - Future stable releases will transition to an official production release keystore.
   - Upgrading across different signing keys requires a clean reinstall (uninstalling the previous version first) due to Android OS signature verification rules (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`).
