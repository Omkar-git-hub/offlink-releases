# Offlink — Official Android Releases & Distribution

[![Offlink Releases](https://img.shields.io/badge/Releases-Official%20Distribution-blue.svg)](https://github.com/Omkar-git-hub/offlink-releases/releases)
[![Source Repository](https://img.shields.io/badge/Source-Omkar--git--hub%2Fofflink-2ea44f.svg)](https://github.com/Omkar-git-hub/offlink)
[![Platform](https://img.shields.io/badge/Platform-Android%207.0%2B%20(API%2024%2B)-green.svg)](docs/installation/android-installation.md)
[![License](https://img.shields.io/badge/License-Open%20Source-lightgrey.svg)](https://github.com/Omkar-git-hub/offlink)
[![Security Policy](https://img.shields.io/badge/Security-Policy%20%26%20Reporting-red.svg)](SECURITY.md)

Welcome to the official public distribution and release portal for **Offlink**, an offline-first, privacy-focused peer-to-peer messaging application for Android.

This repository serves as the official, permanent distribution channel where users, developers, and security auditors can:
- Find and download official Android Application Packages (APKs).
- Inspect version-specific release notes and changelogs.
- Verify cryptographic checksums (SHA-256) and APK signing certificates.
- Access step-by-step installation instructions and platform requirements.
- Troubleshoot installation, permissions, and connectivity issues.
- Review release classification policies, signing key policies, and security disclosures.

> [!NOTE]
> This README is maintained as a **permanent, version-independent guide**. Specific release versions, asset filenames, download artifacts, and cryptographic digests are published directly on the [Official GitHub Releases Page](https://github.com/Omkar-git-hub/offlink-releases/releases).

---

## About Offlink

**Offlink** is engineered for decentralized, secure direct communication over **Bluetooth Low Energy (BLE)** and ad-hoc multi-hop mesh networking. It is designed to function reliably in environments without telecommunications infrastructure, internet access, or central servers.

### Zero Infrastructure Dependency
Offlink core communications operate with **complete independence** from:
- ❌ **Internet connectivity**
- ❌ **Cellular mobile data & SIM cards**
- ❌ **Central messaging servers & accounts**
- ❌ **Cloud push notification services (FCM / APNs)**

### Verified Core Capabilities
The application includes verified, tested implementations of:
- **Autonomous BLE Discovery & Advertising**: Decentralized peer discovery and concurrent peripheral advertising enabling bi-directional connection establishment without external networks.
- **End-to-End Cryptography**: Pairwise session negotiation using X25519 key exchange, Ed25519 identity signatures, and ChaCha20-Poly1305 authenticated encryption with associated data (AEAD) bound to packet envelope headers.
- **Local-First Encrypted Storage**: Fully local Drift (SQLite) database storing conversations, messages, group metadata, and trust state with zero telemetry or remote analytics.
- **Application-Layer Mesh Routing**: Multi-hop store-and-forward mesh routing across intermediate relays. Intermediate nodes forward encrypted ciphertext packets without access to plaintext content.
- **Background Lifecycle Resilience**: Android foreground service (`OfflinkForegroundService`, `connectedDevice` type) enabling continuous mesh discovery, message routing, and reconnection when the app is minimized.
- **Offline Store-and-Forward (DTN)**: Delay-Tolerant Networking engine that queues unacknowledged messages and opportunistically delivers them across hops with exponential backoff and duplicate suppression.
- **Decentralized Group Messaging**: Serverless group creation, membership management, and encrypted pairwise fanout messaging across mesh connections.
- **Privacy-Preserving Location Sharing**: Explicit user-controlled location sharing (one-time coordinates snapshot or time-bounded live sharing sessions) with in-place deterministic bubble updating to protect privacy and prevent disk bloat.
- **Adaptive Battery Optimization**: Dynamic duty-cycled BLE scanning alternating active scan and resting pause windows, combined with zero idle CPU wakeups.
- **Security Hardening & Abuse Defense**: Local serverless peer blocking, sliding-window flood rate limiting with automatic quarantine backoff, deterministic symmetric 60-digit SHA-256 safety fingerprints, and active MITM key-mismatch detection.

---

## Official Downloads

All official APK binaries and verification checksums are published through GitHub Releases:

👉 **[Browse All Official Offlink Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)**

On the Releases page, you can:
- **Download the Latest Available APK**: Select the top release entry to obtain the most recent build.
- **View Release Notes**: Read details about new features, improvements, and bug fixes for that specific build.
- **Download Checksum Files (`SHA256SUMS.txt`)**: Obtain the SHA-256 digests generated at build time.
- **Inspect Source References**: View the exact Git commit SHA and tag corresponding to the release.
- **Access Previous Versions**: Download prior releases or inspect historical changelogs.

> [!TIP]
> **A Note on GitHub Releases Links**: GitHub's automated `/releases/latest` URL only redirects to releases marked as general availability (GA), bypassing pre-releases (Alpha/Beta). Because Offlink currently distributes Alpha pre-releases during early validation, always visit the main **[Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)** listing to view all active builds.

---

## Android System Requirements

Before installing Offlink, ensure your Android device meets the following verified requirements:

| Requirement | Specification | Notes |
| :--- | :--- | :--- |
| **Minimum OS** | Android 7.0 Nougat (API Level 24) | Compatible with Android 7.0 through Android 16+ |
| **Target OS** | Android 16 (API Level 36) | Adheres to modern Android privacy and background execution standards |
| **Architectures** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | Universal APK supporting modern 64-bit and 32-bit hardware |
| **Bluetooth Hardware** | BLE 4.2+ with Peripheral Advertising | Required for bidirectional peer discovery and GATT transmission |
| **Google Services** | None (100% de-Googled friendly) | Operates without Google Play Services or microG frameworks |
| **Internet Access** | Not required | Application requests zero internet permissions |

### Permission Overview
Offlink requests only permissions strictly necessary for local peer-to-peer mesh operations:
- **Nearby Devices / Bluetooth**:
  - *Android 12+ (API 31+)*: `BLUETOOTH_SCAN` (with `neverForLocation`), `BLUETOOTH_ADVERTISE`, and `BLUETOOTH_CONNECT`.
  - *Android 7.0–11 (API 24–30)*: `BLUETOOTH`, `BLUETOOTH_ADMIN`, and `ACCESS_FINE_LOCATION` (enforced by Android OS for BLE radio scanning).
- **Foreground Service**: `FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_CONNECTED_DEVICE` to maintain peer relay connections when minimized.
- **Notifications**: `POST_NOTIFICATIONS` (Android 13+) to display the active foreground mesh service status.
- **Location**: Used strictly for radio discovery on legacy Android versions and when the user explicitly triggers an opt-in location sharing message.

---

## Installation Quick Start

Installing Offlink requires standard Android sideloading:

1. **Visit Releases**: Open the **[Official Releases Page](https://github.com/Omkar-git-hub/offlink-releases/releases)** in your device browser.
2. **Download Artifacts**: Download the `Offlink-<version>.apk` and `SHA256SUMS.txt` files for your intended release.
3. **Verify Integrity**: Compare the SHA-256 hash of your downloaded APK against `SHA256SUMS.txt` (see [APK Verification](#apk-verification)).
4. **Authorize Sideloading**: If prompted by Android (*"Install unknown apps"*), grant permission for your browser or file manager in Android Settings.
5. **Install APK**: Tap the APK file and select **Install**. If prompted by Google Play Protect with an *"Unrecognized app"* notice, tap **More details** > **Install anyway**.
6. **Grant Permissions**: Launch Offlink and allow requested Bluetooth/Nearby Devices, Notification, and Location permissions.
7. **Start Messaging**: Ensure Bluetooth is toggled ON. Nearby Offlink peers will appear automatically on the home screen.

For complete, OS-specific instructions, read the **[Full Installation Guide (INSTALL.md)](INSTALL.md)** and the **[Detailed Android Installation Guide](docs/installation/android-installation.md)**.

---

## APK Verification

Verifying downloaded application packages ensures that your binary was downloaded without corruption and originates authentically from the Offlink maintainers.

### 1. File Integrity Verification (SHA-256)
Every release includes a `SHA256SUMS.txt` asset. To compute your downloaded file's checksum:

- **Windows (PowerShell)**:
  ```powershell
  Get-FileHash -Path .\Offlink-*.apk -Algorithm SHA256
  ```
- **Linux**:
  ```bash
  sha256sum Offlink-*.apk
  ```
- **macOS**:
  ```bash
  shasum -a 256 Offlink-*.apk
  ```

Compare the calculated hash with the value recorded in the release's `SHA256SUMS.txt`.

### 2. Signing Identity Verification (`apksigner`)
A SHA-256 checksum proves file integrity, but verifying the cryptographic signing certificate proves that the APK was built and signed by the authentic developer identity without tampering:

```bash
apksigner verify --verbose --print-certs Offlink-*.apk
```

> [!IMPORTANT]
> A valid checksum only confirms the download was not corrupted or modified from what is hosted in the release. It does not replace cryptographic signature verification. Always consult the **[APK Verification Guide](docs/verification/apk-verification.md)** for in-depth signature verification instructions and failure diagnostics.

---

## Release Channels & Stability

Offlink follows semantic versioning and classifies releases across three maturity tiers:

1. **Alpha (`vX.Y.Z-alpha.N`)**: Early architectural releases intended for protocol validation, field testing, and developer feedback. May be signed with testing credentials.
2. **Beta (`vX.Y.Z-beta.N`)**: Feature-complete builds undergoing wide multi-device community testing.
3. **Stable / GA (`vX.Y.Z`)**: Production releases signed with the official release key, prepared for F-Droid and general public use.

### Upgrade & Signature Compatibility Notice
Android enforces signature continuity: an installed app can only be upgraded by an APK signed with the exact same cryptographic key.
- Initial early alpha releases use a development/testing signing identity.
- When updating from an alpha testing build to a build signed with a different or official production key, Android will report `INSTALL_FAILED_UPDATE_INCOMPATIBLE`.
- In such cases, you must **backup your data, uninstall the older build, and perform a clean install** of the new release.

For complete details on versioning, signing transitions, and release cadence, see the **[Release Policy](docs/distribution/release-policy.md)**.

---

## Troubleshooting & FAQ

| Problem | Cause | Solution |
| :--- | :--- | :--- |
| **"App not installed" / Signature Conflict** | A previous build with a different signing key is installed. | Uninstall the previous version completely, restart the device, and reinstall. |
| **"Blocked by Play Protect"** | The APK is distributed directly outside the Google Play Store. | Tap **More details**, then select **Install anyway**. |
| **No peers discovered** | Bluetooth is disabled or required permissions were denied. | Enable Bluetooth in Android settings; verify **Nearby Devices** (Android 12+) or **Location** (Android 11-) is granted. |
| **Background relay stops when screen is off** | OEM aggressive battery saver terminated the service. | Go to Android Settings > Apps > Offlink > Battery, and choose **Unrestricted**. |
| **Checksum does not match** | File was truncated or corrupted during download. | Re-download the APK from GitHub Releases and re-verify. |

For detailed diagnostic workflows, read the **[Troubleshooting Guide](docs/installation/troubleshooting.md)**.

---

## Official Repository Links

- **Main Source Code Repository**: [https://github.com/Omkar-git-hub/offlink](https://github.com/Omkar-git-hub/offlink) *(Source code, architecture, unit tests, issue tracker)*
- **Official Releases Repository**: [https://github.com/Omkar-git-hub/offlink-releases](https://github.com/Omkar-git-hub/offlink-releases) *(Binaries, release documentation, verification guides)*
- **GitHub Releases Listing**: [https://github.com/Omkar-git-hub/offlink-releases/releases](https://github.com/Omkar-git-hub/offlink-releases/releases)
- **Detailed Installation Guide**: [INSTALL.md](INSTALL.md) & [Android Installation](docs/installation/android-installation.md)
- **APK Verification Guide**: [docs/verification/apk-verification.md](docs/verification/apk-verification.md)
- **Release History**: [RELEASES.md](RELEASES.md)
- **Project Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **Release Policy**: [docs/distribution/release-policy.md](docs/distribution/release-policy.md)
- **F-Droid Distribution Roadmap**: [docs/fdroid/fdroid-readiness.md](docs/fdroid/fdroid-readiness.md)
- **Security Policy & Private Vulnerability Reporting**: [SECURITY.md](SECURITY.md)
- **Bug Reports & Issues**: [https://github.com/Omkar-git-hub/offlink/issues](https://github.com/Omkar-git-hub/offlink/issues)
