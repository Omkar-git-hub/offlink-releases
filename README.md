# Offlink — Official Android Releases & Distribution

[![Offlink Releases](https://img.shields.io/badge/Releases-Official%20Distribution-blue.svg)](https://github.com/Omkar-git-hub/offlink-releases/releases)
[![Source Repository](https://img.shields.io/badge/Source-Omkar--git--hub%2Fofflink-2ea44f.svg)](https://github.com/Omkar-git-hub/offlink)
[![Platform](https://img.shields.io/badge/Platform-Android%207.0%2B%20(API%2024%2B)-green.svg)](docs/installation/android-installation.md)
[![License](https://img.shields.io/badge/License-Open%20Source-lightgrey.svg)](https://github.com/Omkar-git-hub/offlink)
[![Security Policy](https://img.shields.io/badge/Security-Policy%20%26%20Reporting-red.svg)](SECURITY.md)

Welcome to the official public distribution and release portal for **Offlink**, an offline-first, decentralized peer-to-peer messaging application for Android.

This repository serves as the official, permanent distribution channel where users, developers, and security auditors can download official Android Application Packages (APKs), verify cryptographic checksums and signatures, and access installation and troubleshooting documentation.

---

## 📥 Downloads

Select an option below to obtain the official Offlink Android application:

| Action | Target | Description |
| :--- | :--- | :--- |
| 🚀 **[Download Latest Offlink APK](https://github.com/Omkar-git-hub/offlink-releases/releases/latest/download/Offlink.apk)** | `Offlink.apk` | **Recommended.** Directly downloads the latest official Android release. |
| 📦 **[View All Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)** | GitHub Releases | Browse all published versions, changelogs, release notes, and historical APKs. |

### Available Release Assets

Each release provides the following cryptographic distribution assets:

| Asset File | Purpose | Who Should Use It |
| :--- | :--- | :--- |
| **`Offlink.apk`** | Unversioned direct download alias | General users wanting the latest available build |
| **`Offlink-<version>.apk`** | Canonical version-tagged APK (e.g. `Offlink-0.1.0-alpha.4.apk`) | Users archiving specific versions or installing historical builds |
| **`SHA256SUMS.txt`** | Cryptographic SHA-256 digest manifest | Anyone verifying file integrity before installation |

> [!TIP]
> **Direct Download Guarantee**: The link `https://github.com/Omkar-git-hub/offlink-releases/releases/latest/download/Offlink.apk` is a stable, permanent endpoint that always resolves to the latest validated Offlink APK.

---

## ⚡ Quick Start: 5-Step Android Installation

Installing Offlink on your Android device is straightforward:

1. **Download the APK**:
   Tap **[Download Latest Offlink APK](https://github.com/Omkar-git-hub/offlink-releases/releases/latest/download/Offlink.apk)** in your mobile web browser.
2. **Open the Downloaded File**:
   Once downloaded, tap the download notification or locate the file in your device's **Files** or **Downloads** folder.
3. **Allow Installation from Unknown Apps**:
   If Android displays a security notice stating *"For your security, your phone is not allowed to install unknown apps from this source"*, tap **Settings** and toggle **Allow from this source** ON, then tap **Install**.
4. **Bypass Google Play Protect (First-Time Notice)**:
   If Google Play Protect displays *"Unrecognized app"*, tap **More details** and then select **Install anyway**.
5. **Launch & Grant Radio Permissions**:
   Open Offlink. When prompted, allow **Nearby Devices / Bluetooth** and **Notifications** permissions. Ensure your device's Bluetooth is toggled **ON**. Nearby Offlink peers will automatically appear on your screen!

For an in-depth walkthrough with screenshots and device-specific settings, consult the **[Complete Installation Guide (INSTALL.md)](INSTALL.md)** and the **[Detailed Android Guide](docs/installation/android-installation.md)**.

---

## 🔍 Cryptographic Verification

Verifying your download proves that the file was not altered, truncated, or corrupted in transit, and guarantees authentic cryptographic origin.

### 1. File Integrity Verification (SHA-256)
Every release includes a `SHA256SUMS.txt` file containing the SHA-256 hash calculated during build.

- **Windows (PowerShell)**:
  ```powershell
  Get-FileHash -Path .\Offlink*.apk -Algorithm SHA256
  ```
- **Linux / macOS**:
  ```bash
  sha256sum Offlink*.apk
  # or on macOS:
  shasum -a 256 Offlink*.apk
  ```
- **Android (via Termux)**:
  ```bash
  sha256sum Offlink*.apk
  ```

Compare the output hash against the hash listed in `SHA256SUMS.txt`. If they match, your APK is complete and unmodified.

### 2. Signing Identity Verification (`apksigner`)
To cryptographically verify the developer signing certificate and ensure the APK has not been re-packaged:

```bash
apksigner verify --verbose --print-certs Offlink*.apk
```

Expected verification results:
- **Signer #1 certificate DN**: Contains authentic Offlink developer attributes.
- **Signature scheme**: Verified using APK Signature Scheme v2 (or v3).
- **Integrity**: `Verifies: true`.

For full signature inspection steps and certificate fingerprint reference, see the **[APK Verification Guide](docs/verification/apk-verification.md)**.

---

## 📱 Platform & System Requirements

| Requirement | Specification | Details |
| :--- | :--- | :--- |
| **Minimum OS** | Android 7.0 Nougat (API Level 24) | Compatible with Android 7.0 through Android 16+ |
| **Target OS** | Android 16 (API Level 36) | Modern Android privacy and background execution compliance |
| **Hardware Architecture** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | Universal APK supporting modern 64-bit and 32-bit hardware |
| **Bluetooth Radio** | BLE 4.2+ with Peripheral Advertising | Required for peer discovery and bidirectional mesh communication |
| **Google Services** | None (100% de-Googled friendly) | Operates without Google Play Services or microG frameworks |
| **Internet Access** | None | Offlink contains zero internet permissions |

### Permission Transparency
Offlink requests only the permissions strictly required to provide offline mesh networking:
- **Nearby Devices / Bluetooth**:
  - *Android 12+ (API 31+)*: `BLUETOOTH_SCAN` (configured with `neverForLocation`), `BLUETOOTH_ADVERTISE`, and `BLUETOOTH_CONNECT`.
  - *Android 7.0–11 (API 24–30)*: `BLUETOOTH`, `BLUETOOTH_ADMIN`, and `ACCESS_FINE_LOCATION` (mandated by Android OS to scan for Bluetooth radios).
- **Foreground Service**: `FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_CONNECTED_DEVICE` to maintain peer discovery and relay messages when the app is in the background.
- **Notifications**: `POST_NOTIFICATIONS` (Android 13+) to show foreground service status and deliver incoming offline message alerts.
- **Location**: Used strictly for radio scanning on older Android versions and for optional, user-initiated location snapshot messages.

---

## 🌐 About Offlink

**Offlink** is engineered for decentralized, secure direct communication over **Bluetooth Low Energy (BLE)** and ad-hoc multi-hop mesh networking. It is designed to function reliably in environments without telecommunications infrastructure, internet access, or central servers.

### Zero Infrastructure Dependency
Offlink core communications operate with **complete independence** from:
- ❌ **Internet connectivity**
- ❌ **Cellular mobile data & SIM cards**
- ❌ **Central messaging servers & accounts**
- ❌ **Cloud push notification services (FCM / APNs)**

### Key Features
- **Decentralized BLE Mesh**: Autonomous peer discovery and multi-hop message relay.
- **End-to-End Cryptography**: Pairwise session negotiation using X25519, Ed25519, and ChaCha20-Poly1305 AEAD.
- **Local-First Encrypted Storage**: Fully local Drift (SQLite) database with zero telemetry.
- **Delay-Tolerant Networking (DTN)**: Offline store-and-forward queue with exponential backoff.
- **Foreground Mesh Relay**: Continuous mesh routing when the app is minimized.
- **Privacy Controls**: Serverless peer blocking, rate limiting, and 60-digit safety verification numbers.

---

## 🏷️ Release Channels & Versioning

Offlink follows [Semantic Versioning 2.0.0](https://semver.org/) and classifies releases across three tiers:

1. **Alpha (`vX.Y.Z-alpha.N`)**: Early architectural releases for protocol validation and field testing.
2. **Beta (`vX.Y.Z-beta.N`)**: Feature-complete builds undergoing wide multi-device community testing.
3. **Stable / GA (`vX.Y.Z`)**: Production releases signed with the official release key, prepared for F-Droid and general public distribution.

For complete details on versioning and release cadence, see the **[Release Policy](docs/distribution/release-policy.md)** and **[Release History (RELEASES.md)](RELEASES.md)**.

---

## 🛠️ Troubleshooting & FAQ

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **"App not installed" / Signature Conflict** | A previous build signed with a different key is present on your device. | Completely uninstall the existing Offlink app, restart your device, and install the new release. |
| **"Blocked by Play Protect"** | Offlink is distributed directly via GitHub rather than the Google Play Store. | Tap **More details**, then select **Install anyway**. |
| **No peers appear on screen** | Bluetooth is off or Nearby Devices permission was denied. | Toggle Bluetooth ON in Android Settings and grant **Nearby Devices** (or Location on Android 11-). |
| **Relay stops when app is in background** | OEM aggressive battery optimization stopped the service. | Go to Android Settings > Apps > Offlink > Battery, and choose **Unrestricted**. |
| **Download link returns 404** | Temporary GitHub CDN synchronization delay. | Refresh the page or visit the **[All Releases Page](https://github.com/Omkar-git-hub/offlink-releases/releases)**. |

For additional diagnostics, read the **[Troubleshooting Guide](docs/installation/troubleshooting.md)**.

---

## 🔗 Official Links & Resources

- **Main Source Code Repository**: [https://github.com/Omkar-git-hub/offlink](https://github.com/Omkar-git-hub/offlink) *(Source code, architecture, unit tests, issue tracker)*
- **Official Releases Repository**: [https://github.com/Omkar-git-hub/offlink-releases](https://github.com/Omkar-git-hub/offlink-releases) *(Binaries, release documentation, verification guides)*
- **Download Latest APK**: [https://github.com/Omkar-git-hub/offlink-releases/releases/latest/download/Offlink.apk](https://github.com/Omkar-git-hub/offlink-releases/releases/latest/download/Offlink.apk)
- **All Releases Listing**: [https://github.com/Omkar-git-hub/offlink-releases/releases](https://github.com/Omkar-git-hub/offlink-releases/releases)
- **Full Installation Guide**: [INSTALL.md](INSTALL.md) & [Android Installation](docs/installation/android-installation.md)
- **APK Verification Guide**: [docs/verification/apk-verification.md](docs/verification/apk-verification.md)
- **Release History**: [RELEASES.md](RELEASES.md)
- **Project Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **Release Policy**: [docs/distribution/release-policy.md](docs/distribution/release-policy.md)
- **F-Droid Distribution Roadmap**: [docs/fdroid/fdroid-readiness.md](docs/fdroid/fdroid-readiness.md)
- **Security Policy & Vulnerability Reporting**: [SECURITY.md](SECURITY.md)
- **Bug Reports & Issues**: [https://github.com/Omkar-git-hub/offlink/issues](https://github.com/Omkar-git-hub/offlink/issues)
