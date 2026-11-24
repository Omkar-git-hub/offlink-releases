# F-Droid Readiness Assessment & Roadmap — Offlink

This document evaluates the current readiness of the Offlink Android application for distribution via the **F-Droid** free and open-source Android app repository.

---

## 1. Executive Summary

- **Current Status**: **In Preparation (Not Yet Submitted)**
- **Target Channel**: F-Droid Main Repository
- **Compatibility Score**: **High (No proprietary blobs, fully open-source dependencies)**
- **Package Identifier**: `io.github.omkar_git_hub.offlink`
- **Action Required Before Submission**: Finalize official open-source license text file (e.g. Apache-2.0 / GPL-3.0) in source repo, transition to permanent production signing key, and publish Fastlane metadata structure.

> [!WARNING]
> Offlink is **NOT** currently published on F-Droid. Do not claim F-Droid availability until the upstream review and build recipe are formally accepted by the F-Droid team.

---

## 2. Dependency & Licensing Audit

F-Droid requires that 100% of the application code, build tools, and third-party libraries be free/libre open-source software (FLOSS) without non-free dependencies or proprietary analytics/trackers.

### Dependency Audit
All dependencies declared in `pubspec.yaml` have been audited:

| Package | Purpose | Upstream License | F-Droid Compatible |
| :--- | :--- | :--- | :--- |
| `flutter` | UI framework | BSD-3-Clause | ✅ Yes |
| `flutter_blue_plus` | Bluetooth Low Energy transport | BSD-3-Clause | ✅ Yes |
| `flutter_ble_peripheral` | Peripheral BLE advertising | MIT | ✅ Yes |
| `flutter_riverpod` | State management | MIT | ✅ Yes |
| `drift` | Local SQLite database | MIT | ✅ Yes |
| `sqlite3_flutter_libs` | SQLite C library packaging | MIT | ✅ Yes |
| `path_provider` / `path` | Local filesystem paths | BSD-3-Clause | ✅ Yes |
| `cryptography` / `cryptography_flutter` | Cryptographic primitives | Apache-2.0 | ✅ Yes |
| `flutter_secure_storage` | Hardware-backed keystore | BSD-3-Clause | ✅ Yes |
| `geolocator` | Android location access | MIT | ✅ Yes |

### Proprietary Blob Inspection
- **Google Play Services**: ❌ **None**. No `com.google.android.gms` libraries are included.
- **Firebase / Push Notifications**: ❌ **None**. No Google Services plugins or Firebase libraries are included.
- **Analytics / Tracking**: ❌ **Zero telemetry**. No tracking SDKs exist.
- **Anti-Features**: Offlink does not track users, serve advertisements, or depend on non-free network services.

---

## 3. Build Reproducibility & Build System Analysis

### Command-Line Build Capability
F-Droid builds all applications from source on headless Debian Linux build servers (`fdroidserver`).
- Offlink builds cleanly from the terminal using standard tooling:
  ```bash
  flutter pub get
  flutter build apk --release
  ```
- No proprietary build steps or custom IDE plugins are required.

### F-Droid Metadata Recipe Draft (`metadata/io.github.omkar_git_hub.offlink.yml`)
```yaml
Categories:
  - Security
  - Connectivity
License: <To be confirmed>
AuthorName: Omkar Nikam
SourceCode: https://github.com/Omkar-git-hub/offlink
IssueTracker: https://github.com/Omkar-git-hub/offlink/issues
Changelog: https://github.com/Omkar-git-hub/offlink-releases/blob/main/CHANGELOG.md

AutoName: Offlink
Description: |-
  Offline-first, privacy-first peer-to-peer messaging over Bluetooth Low Energy.
  Offlink operates without internet, cellular data, or central servers.

Builds:
  - versionName: 0.1.0-alpha.4
    versionCode: 4
    commit: v0.1.0-alpha.4
    subdir: offlink
    output: build/app/outputs/flutter-apk/app-release.apk
    flutter: yes
    gradle:
      - yes

AutoUpdateMode: Version
UpdateCheckMode: Tags
```

---

## 4. Signing Differences: GitHub Releases vs F-Droid

It is vital to understand the architectural difference between GitHub Releases and F-Droid:

1. **GitHub Releases**:
   - The APK is built by Offlink's CI and signed with Offlink's official release signing key.
2. **F-Droid Official Repository**:
   - F-Droid checks out the source code, compiles the APK in an isolated container, and signs the resulting APK with **F-Droid's own signing key**.
   - Consequently, an APK installed from GitHub cannot be upgraded in-place from F-Droid (and vice-versa) without reinstalling due to Android's signature enforcement.
3. **F-Droid Reproducible Builds**:
   - If Offlink enables reproducible builds matching F-Droid's build output, F-Droid can attach Offlink's official signature.

---

## 5. F-Droid Readiness Checklist

- [x] Zero proprietary SDKs or closed-source libraries.
- [x] Zero telemetry, tracking, or crash analytics.
- [x] Independent of Google Play Services.
- [x] Builds cleanly via standard `flutter` and `gradle` CLI.
- [x] Verified minimum SDK (24) and target SDK (36).
- [x] Package ID configured as `io.github.omkar_git_hub.offlink` in source Gradle configuration.
- [ ] Finalize official open-source license file in `offlink` repository.
- [ ] Transition from testing keystore to permanent production signing key.
- [ ] Prepare Fastlane metadata structure (`fastlane/metadata/android/en-US/`).
- [ ] Submit merge request to `fdroiddata` repository once stable v1.0.0 is reached.
