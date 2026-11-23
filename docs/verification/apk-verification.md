# APK Verification Guide — Offlink

This document explains how to independently verify the cryptographic integrity, authentic checksums, package metadata, and signing certificate of downloaded Offlink Android Application Packages (APKs).

---

## 1. SHA-256 Checksum Verification

Validating the SHA-256 checksum ensures the file was downloaded completely without corruption, network truncation, or tampering.

### Official Values for `v0.1.0-alpha.1`

| File | SHA-256 Digest |
| :--- | :--- |
| `Offlink-0.1.0-alpha.1.apk` | `e10a26c0fdc8907f50ad59cbff51ca02994506250067484e8b59ccf2ef4239e7` |
| `SHA256SUMS.txt` | `321b0fc2dd8e078ea0ba6b7185ee66657c79db151c8db1a34b22db74087b21ec` |

---

### Verification Commands

#### Linux
```bash
sha256sum -c SHA256SUMS.txt
# Expected output:
# Offlink-0.1.0-alpha.1.apk: OK
```

Or calculate manually:
```bash
sha256sum Offlink-0.1.0-alpha.1.apk
```

#### macOS
```bash
shasum -a 256 Offlink-0.1.0-alpha.1.apk
```

#### Windows (PowerShell)
```powershell
Get-FileHash -Path .\Offlink-0.1.0-alpha.1.apk -Algorithm SHA256
```

#### Android (Termux)
```bash
sha256sum Offlink-0.1.0-alpha.1.apk
```

---

## 2. APK Signature Verification (`apksigner`)

To verify that the APK binary is properly signed and conforms to Android's APK Signature Scheme:

### Command
```bash
apksigner verify --verbose --print-certs Offlink-0.1.0-alpha.1.apk
```

### Expected Output
```text
Verifies
Verified using v1 scheme (JAR signing): false
Verified using v2 scheme (APK Signature Scheme v2): true
Verified using v3 scheme (APK Signature Scheme v3): false
Number of signers: 1

Signer #1 certificate DN: C=US, O=Android, CN=Android Debug
Signer #1 certificate SHA-256 digest: df03904dbb6579c665a55f39c53472056048495c004422f0add2153924de06df
Signer #1 certificate SHA-1 digest: 1a4551631d083108a5b34aebd6102e947882652c
Signer #1 certificate MD5 digest: bff99f89f7b16564b3e1dd1b6acb0b1d
```

---

## 3. Package & Manifest Verification (`aapt`)

You can inspect the compiled Android Manifest, package name, version, and requested permissions directly from the binary:

```bash
aapt dump badging Offlink-0.1.0-alpha.1.apk
```

### Expected Verification Metrics
- `package: name='com.example.offlink' versionCode='1' versionName='0.1.0-alpha.1'`
- `sdkVersion:'24'` (Android 7.0)
- `targetSdkVersion:'36'` (Android 16)
- `native-code: 'arm64-v8a' 'armeabi-v7a' 'x86_64'`
- Permissions: Only BLE, foreground service, wake lock, post notifications, and coarse/fine location.
