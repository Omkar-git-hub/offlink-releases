# Distribution & Release Policy — Offlink

This document governs the release lifecycle, distribution channels, signing strategy, repository boundaries, and asset expectations for the Offlink Android project.

---

## 1. Dual-Repository Architecture & Boundaries

Offlink strictly enforces a dual-repository architecture to separate application development from binary distribution:

```
┌────────────────────────────────────────────────────────┐
│  Source Repository:                                    │
│  https://github.com/Omkar-git-hub/offlink             │
│  - Application source code (Flutter / Dart)            │
│  - Architecture documentation                          │
│  - Unit, widget, integration, and fuzzing test suites  │
│  - Core developer CI workflows                         │
│  - Issue tracker for bugs and feature discussions      │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼ (Automated / Manual Release Pipeline)
┌────────────────────────────────────────────────────────┐
│  Distribution Repository:                              │
│  https://github.com/Omkar-git-hub/offlink-releases    │
│  - Official public releases & GitHub Releases hosting  │
│  - Binary APK distribution and release notes           │
│  - Cryptographic checksums (SHA256SUMS.txt)            │
│  - Installation, verification, and troubleshooting docs│
│  - F-Droid readiness and packaging metadata            │
│  - Independent distribution release workflows          │
└────────────────────────────────────────────────────────┘
```

### Repository Rules
- **No Source Code in Distribution Repository**: Application Flutter/Dart code is maintained exclusively in `offlink`.
- **No Binaries Committed to Git History**: APK binaries must never be committed into Git tracking trees; all binaries are distributed exclusively as GitHub Release assets.
- **No Credentials or Secrets Committed**: Private keystores, passwords, and access tokens must never be committed to either repository.
- **Unidirectional Build Flow**: The distribution repository references commits and tags from the source repository, but never modifies the source repository.

---

## 2. Release Classification & Stability Tiers

Offlink categorizes releases into three distinct maturity tiers:

| Tier | Identifier Pattern | Target Audience | Stability Expectations | Signing Key |
| :--- | :--- | :--- | :--- | :--- |
| **Alpha (Pre-Release)** | `vX.Y.Z-alpha.N` | Developers, security researchers, early testers | Protocol validation, active architectural evolution. May require clean reinstalls across versions. | Testing / Alpha Keystore |
| **Beta (Pre-Release)** | `vX.Y.Z-beta.N` | Community testers, field testers | Feature-complete, stabilized wire protocols and database schemas. Multi-device field testing. | Candidate Release Keystore |
| **Stable (General Availability)** | `vX.Y.Z` | General public, privacy-focused end users | Audited security, long-term upgrade compatibility, production signing, F-Droid distribution. | Official Production Keystore |

---

## 3. Versioning Scheme

Offlink adheres strictly to [Semantic Versioning 2.0.0](https://semver.org/):

$$\text{v}\text{MAJOR}.\text{MINOR}.\text{PATCH}[-\text{PRERELEASE}]$$

- **MAJOR**: Incremented when backward-incompatible wire protocol changes or major cryptographic renegotiation schemes are introduced.
- **MINOR**: Incremented when new backward-compatible capabilities (e.g., new transport adapters, UI modules) are added.
- **PATCH**: Incremented for backward-compatible bug fixes, performance optimizations, and security patches.
- **PRERELEASE**: Denoted as `-alpha.<n>` or `-beta.<n>` during pre-production cycles.
- **Android Versioning**:
  - `versionName`: Matches the release version (e.g. `0.1.0-alpha.4`).
  - `versionCode`: Strictly monotonic positive integer incremented with every official build.

---

## 4. Signing Key Policy & Upgrade Transitions

### Android Cryptographic Identity Rules
The Android operating system requires that every installed package be cryptographically signed. When updating an existing application, the OS verifies that the certificate of the incoming APK matches the certificate of the currently installed app. If the certificates do not match, Android immediately aborts installation with `INSTALL_FAILED_UPDATE_INCOMPATIBLE`.

### Current State (Alpha Pre-Releases)
- Early alpha releases (e.g. `v0.1.0-alpha.1`, `v0.1.0-alpha.4`) are signed with developer testing credentials (`CN=Android Debug`).
- This allows rapid iteration, automated CI verification, and physical device testing without prematurely exposing production key management.

### Production Release Key Transition
- For production General Availability (GA) releases, a dedicated, air-gapped production keystore will be introduced.
- **Clean Install Requirement**: Upgrading from an early alpha testing build to an official production-signed release will require an explicit uninstall of the alpha build followed by a clean installation of the production APK. In-place upgrades across this boundary are impossible due to Android OS signature verification.
- **Key Continuity**: Once the official production release key is established, all subsequent stable and maintenance releases will maintain strict signature continuity to enable seamless in-place updates.

---

## 5. Official Release Asset Standard

Every official release published on GitHub Releases must adhere to a standardized asset structure:

```text
GitHub Release Assets:
├── Offlink-<version>.apk       # Universal APK binary (arm64-v8a, armeabi-v7a, x86_64)
└── SHA256SUMS.txt             # Cryptographic SHA-256 digests of all distributed assets
```

### Required Release Metadata
Every release description must document:
1. **Release Classification**: Clear indication of Alpha, Beta, or Stable.
2. **Release Version & Build Code**: `versionName` and Android `versionCode`.
3. **Source Reference**: Exact Git commit SHA and tag in `Omkar-git-hub/offlink`.
4. **Android Compatibility**: Supported minimum and target SDK versions.
5. **Signing Identity**: Certificate Common Name (CN) and certificate SHA-256 fingerprint.
6. **Changelog & Features**: Categorized list of additions, fixes, and security improvements.
7. **Known Issues & Limitations**: Any known constraints (e.g., OEM battery management requirements).
8. **Upgrade & Installation Notes**: Guidance on whether in-place upgrades or clean installs are required.

---

## 6. Forward Compatibility & Protocol Evolutions

1. **Packet Protocol Evolution**: The Offlink packet envelope protocol includes version headers. Intermediate mesh routing nodes forward unrecognized packet payloads opaquely rather than dropping them, preventing network partitioning during staged updates.
2. **Local Database Migrations**: Drift (SQLite) database schema migrations are managed through automated, regression-tested migration steps.
3. **Security Vulnerability Fixes**: If a critical vulnerability is identified, hotfix releases will be deployed out-of-band across both repositories with security advisories.
