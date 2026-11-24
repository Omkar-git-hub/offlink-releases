# APK Verification Guide — Offlink

This document provides step-by-step instructions for independently verifying the cryptographic integrity, authenticity, and signing certificates of official Offlink Android Application Packages (APKs).

---

## 1. Understanding Integrity vs. Developer Identity

Before verifying binaries, it is essential to understand the difference between **file integrity** and **cryptographic identity**:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        APK VERIFICATION LAYERS                         │
├───────────────────────────────────┬────────────────────────────────────┤
│ 1. File Integrity (SHA-256)       │ 2. Developer Identity (apksigner)   │
├───────────────────────────────────┼────────────────────────────────────┤
│ • Validates download completeness │ • Proves who signed the binary     │
│ • Detects truncation or bit rot   │ • Proves code was not modified     │
│ • Compares with SHA256SUMS.txt    │   since signing by developer key   │
│ • Does NOT prove origin identity  │ • Protects against forged releases │
└───────────────────────────────────┴────────────────────────────────────┘
```

> [!WARNING]
> **A SHA-256 Checksum Does NOT Prove Developer Identity**:
> A checksum only confirms that the file on your device is byte-for-byte identical to the file referenced in `SHA256SUMS.txt`. If an attacker were to compromise a hosting server, they could alter both the APK and the `SHA256SUMS.txt` file simultaneously.
>
> True origin authentication requires verifying the **cryptographic signature** embedded within the APK itself using tools such as `apksigner`.

---

## 2. Step 1: File Integrity Verification (SHA-256)

### Where to Obtain Checksum Files
Every official release published on [GitHub Releases](https://github.com/Omkar-git-hub/offlink-releases/releases) includes an accompanying `SHA256SUMS.txt` asset containing the official build digests.

### Verification Commands by Operating System

#### Windows (PowerShell)
Open PowerShell in the folder containing your downloaded APK and run:
```powershell
Get-FileHash -Path .\Offlink-*.apk -Algorithm SHA256
```

#### Linux
Open a terminal in the download folder and verify against `SHA256SUMS.txt`:
```bash
sha256sum -c SHA256SUMS.txt
```
Or compute manually:
```bash
sha256sum Offlink-*.apk
```

#### macOS
```bash
shasum -a 256 Offlink-*.apk
```

#### Android (via Termux)
```bash
sha256sum Offlink-*.apk
```

### Interpreting SHA-256 Results
- **Hashes Match**: The APK was downloaded completely without byte corruption or transit errors.
- **Hashes Differ**: **DO NOT INSTALL.** The download was either interrupted, corrupted, or altered. Delete the file and re-download from the official Releases page.

---

## 3. Step 2: APK Signature Verification (`apksigner`)

Android APKs are signed with cryptographic certificates according to the Android APK Signature Scheme (v2, v3, or v4). Using the official Android SDK tool `apksigner`, you can verify that:
1. The binary's signature is cryptographically valid and untampered.
2. The signing certificate matches the expected developer identity.

`apksigner` is included in the Android SDK Build-Tools (e.g. `build-tools/<version>/apksigner`).

### Signature Verification Command
```bash
apksigner verify --verbose --print-certs Offlink-<version>.apk
```

### Understanding the Output

A valid signature output will report:
```text
Verifies
Verified using v1 scheme (JAR signing): false
Verified using v2 scheme (APK Signature Scheme v2): true
Verified using v3 scheme (APK Signature Scheme v3): false
Number of signers: 1
Signer #1 certificate DN: ...
Signer #1 certificate SHA-256 digest: ...
```

Key indicators:
- **`Verifies`**: Confirms that the cryptographic signature covers all archive contents and the archive has not been modified since it was signed.
- **`Verified using v2 scheme: true`**: Confirms valid Android Signature Scheme v2 enforcement.
- **`Signer #1 certificate SHA-256 digest`**: The cryptographic fingerprint of the public key certificate used to sign the APK.

---

## 4. Signing Identities & Release Stages

### Alpha Testing Phase
Initial pre-releases (such as developer Alpha builds) are signed with a development/testing signing identity (`CN=Android Debug`) to facilitate early hardware testing and protocol validation:
- **Signer DN**: `CN=Android Debug, O=Android, C=US`
- **Certificate SHA-256**: `df03904dbb6579c665a55f39c53472056048495c004422f0add2153924de06df`

### Official Production Release Phase
Official production builds are signed with a dedicated release keystore managed through secure, fail-closed CI/CD pipelines.

> [!IMPORTANT]
> **Android Signature Enforcement**:
> Android OS enforces that app upgrades must match the certificate of the installed version. When transitioning from an Alpha testing build to an official production release, Android will reject an in-place upgrade (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`). Users must uninstall the testing build before installing the production release.

---

## 5. Step 3: Package & Manifest Inspection (`aapt2`)

To inspect compiled package metadata, Android SDK targets, and declared permissions:

```bash
aapt2 dump badging Offlink-<version>.apk
```

### Verified Baseline Attributes
- **Package Name**: `io.github.omkar_git_hub.offlink`
- **Minimum SDK**: `24` (Android 7.0)
- **Target SDK**: `36` (Android 16)
- **Native Architectures**: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- **Permissions Requested**:
  - `BLUETOOTH`, `BLUETOOTH_ADMIN` (legacy)
  - `BLUETOOTH_SCAN`, `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT` (Android 12+)
  - `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
  - `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_CONNECTED_DEVICE`
  - `POST_NOTIFICATIONS`, `WAKE_LOCK`

Any official APK should **NEVER** request permissions for internet (`android.permission.INTERNET`), phone state, contacts, or external storage.

---

## 6. Interpreting Verification Failures

| Failure Symptom | Likely Cause | Required Action |
| :--- | :--- | :--- |
| **`sha256sum: FAILED`** | Incomplete download or truncated file. | Delete the file, clear browser cache, and re-download from GitHub Releases. |
| **`DOES NOT VERIFY` from `apksigner`** | The APK archive was modified or corrupted after signing. | **Do not install.** Discard the file immediately. |
| **Unexpected Certificate Digest** | APK was re-signed with an unauthorized or unknown certificate. | **Do not install.** Verify download source. Ensure the APK was retrieved directly from `Omkar-git-hub/offlink-releases`. |
| **`INSTALL_FAILED_UPDATE_INCOMPATIBLE`** | An APK signed with a different key is already installed on device. | Uninstall the previous build from your phone and perform a clean install. |
