# Offlink — Official Android Releases & Distribution

[![Offlink Release](https://img.shields.io/badge/Release-v0.1.0--alpha.1-blue.svg)](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.1)
[![Channel](https://img.shields.io/badge/Channel-Developer%20Alpha-orange.svg)](https://github.com/Omkar-git-hub/offlink-releases/releases)
[![Source Repository](https://img.shields.io/badge/Source-Omkar--git--hub%2Fofflink-2ea44f.svg)](https://github.com/Omkar-git-hub/offlink)
[![Platform](https://img.shields.io/badge/Platform-Android%207.0%2B%20(API%2024%2B)-green.svg)](docs/installation/android-installation.md)
[![License](https://img.shields.io/badge/License-Open%20Source-lightgrey.svg)](https://github.com/Omkar-git-hub/offlink)

Welcome to the official public distribution and release repository for **Offlink**, an offline-first, privacy-focused peer-to-peer messaging application for Android.

This repository serves as the official distribution channel where users can download verified Android Application Packages (APKs), inspect release notes, verify cryptographic signatures and checksums, and find installation and troubleshooting documentation.

---

## About Offlink

**Offlink** is engineered for decentralized, secure direct communication over **Bluetooth Low Energy (BLE)** and ad-hoc multi-hop mesh routing. It is specifically designed to function reliably in environments without standard telecommunications infrastructure.

### Zero Infrastructure Dependency
Offlink core communications operate with **complete independence** from:
- ❌ **Internet connectivity**
- ❌ **Cellular networks & SIM cards**
- ❌ **Central messaging servers**
- ❌ **Cloud push notification services (FCM / APNs)**

### Verified Core Capabilities (v0.1.0-alpha.1)
The application currently includes verified implementations of:
- **BLE Discovery & Peripheral Advertising**: Autonomous discovery of nearby peers and concurrent peripheral advertising allowing bi-directional connection establishment without internet.
- **End-to-End Cryptography**: Pairwise session negotiation using X25519 key exchange, Ed25519 identity signatures, and ChaCha20-Poly1305 authenticated encryption with associated data (AEAD) bound to packet envelope headers.
- **Local-First Encrypted Storage**: Fully local Drift (SQLite) database storing conversations, messages, group metadata, and trust state with zero telemetry or remote analytics.
- **Application-Layer Mesh Routing**: Multi-hop store-and-forward mesh routing across intermediate relays. Intermediate nodes forward encrypted ciphertext packets without access to plaintext content.
- **Background Lifecycle Resilience**: Foreground service (`connectedDevice` type) enabling continuous mesh discovery, message routing, and reconnection when the app is minimized or the screen is off.
- **Offline Store-and-Forward (DTN)**: Delay-Tolerant Networking engine that queues unacknowledged messages and opportunisticly delivers them across hops with exponential backoff and duplicate suppression.
- **Decentralized Group Messaging**: Serverless group creation, membership management, and encrypted pairwise fanout messaging across mesh connections.
- **Privacy-Preserving Location Sharing**: Explicit user-controlled location sharing (one-time coordinates snapshot or time-bounded live sharing sessions) with in-place deterministic bubble updating to protect privacy and prevent disk bloat.
- **Adaptive Battery Optimization**: Dynamic duty-cycled BLE scanning (alternating scan and resting pause windows) reducing radio energy consumption by 33% to 94% across active, balanced, and low-power modes, combined with zero idle CPU timer wakeups.
- **Security Hardening & Abuse Defense**: Local serverless peer blocking, sliding-window flood rate limiting with automatic 30-second quarantine backoff, deterministic symmetric 60-digit SHA-256 safety fingerprints, and active MITM key-mismatch detection.

---

## Download Offlink

All official APK binaries are published through [GitHub Releases](https://github.com/Omkar-git-hub/offlink-releases/releases).

### Latest Release: `v0.1.0-alpha.1` (Pre-Release)
- **Release Date**: November 23, 2026
- **Stability Tier**: **Developer Alpha (Pre-Release)**
- **Package Name**: `com.example.offlink`
- **Minimum Android**: Android 7.0 (API level 24)
- **Target Android**: Android 16 (API level 36)
- **Supported CPU Architectures**: `arm64-v8a`, `armeabi-v7a`, `x86_64`

| Download Asset | File Type | Size | SHA-256 Checksum |
| :--- | :--- | :--- | :--- |
| [**Offlink-0.1.0-alpha.1.apk**](https://github.com/Omkar-git-hub/offlink-releases/releases/download/v0.1.0-alpha.1/Offlink-0.1.0-alpha.1.apk) | Android APK | ~57.3 MB | `e10a26c0fdc8907f50ad59cbff51ca02994506250067484e8b59ccf2ef4239e7` |
| [**SHA256SUMS.txt**](https://github.com/Omkar-git-hub/offlink-releases/releases/download/v0.1.0-alpha.1/SHA256SUMS.txt) | Checksum File | 92 B | `4ca2c8cf02572a85dd06379c448843d9f9f5d230286e062e571b2e8477b51a20` |


> [!IMPORTANT]
> **Alpha Signing Notice**:
> This initial alpha release is signed with a development/testing signing identity for early testing and validation. When the permanent official production release keystore is introduced in the automated release pipeline, updating to production builds will require a clean reinstall (uninstalling this alpha build first) due to Android's signature verification rules (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`). Read our [Release Policy](docs/distribution/release-policy.md) and [APK Verification Guide](docs/verification/apk-verification.md) for full details.

---

## Quick Start & Installation

1. **Download the APK**: Download `Offlink-0.1.0-alpha.1.apk` from the [Latest Release](https://github.com/Omkar-git-hub/offlink-releases/releases/latest).
2. **Verify Integrity**: Compare the file's SHA-256 checksum with `SHA256SUMS.txt` (see [Verification Instructions](docs/verification/apk-verification.md)).
3. **Allow Sideloading**: On your Android device, allow your browser or file manager to "Install unknown apps" in Android Settings.
4. **Install & Grant Permissions**: Open the downloaded APK, tap **Install**, and grant required permissions (Bluetooth / Nearby Devices, Location, Notifications).
5. **Start Messaging**: Launch Offlink on two or more nearby devices. Ensure Bluetooth is enabled on all devices to discover peers and begin communication.

For complete step-by-step instructions and troubleshooting, read [INSTALL.md](INSTALL.md) and [Android Installation Guide](docs/installation/android-installation.md).

---

## Integrity & Security Verification

Before running any downloaded binary on your device, verify its SHA-256 checksum:

### Linux / macOS
```bash
sha256sum Offlink-0.1.0-alpha.1.apk
```
Expected output:
```text
e10a26c0fdc8907f50ad59cbff51ca02994506250067484e8b59ccf2ef4239e7  Offlink-0.1.0-alpha.1.apk
```

### Windows (PowerShell)
```powershell
Get-FileHash -Path .\Offlink-0.1.0-alpha.1.apk -Algorithm SHA256
```

For advanced signature verification using `apksigner`, refer to [docs/verification/apk-verification.md](docs/verification/apk-verification.md).

---

## Repository Links & Official Resources

- **Main Source Code Repository**: [https://github.com/Omkar-git-hub/offlink](https://github.com/Omkar-git-hub/offlink)
- **Official Releases Repository**: [https://github.com/Omkar-git-hub/offlink-releases](https://github.com/Omkar-git-hub/offlink-releases)
- **GitHub Releases Page**: [https://github.com/Omkar-git-hub/offlink-releases/releases](https://github.com/Omkar-git-hub/offlink-releases/releases)
- **Bug Reports & Issues**: [https://github.com/Omkar-git-hub/offlink/issues](https://github.com/Omkar-git-hub/offlink/issues)
- **Security Policy & Reporting**: [SECURITY.md](SECURITY.md)
- **Release History**: [RELEASES.md](RELEASES.md)
- **Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **F-Droid Distribution Roadmap**: [docs/fdroid/fdroid-readiness.md](docs/fdroid/fdroid-readiness.md)
