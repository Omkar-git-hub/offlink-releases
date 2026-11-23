# Distribution & Release Policy — Offlink

This document governs the release lifecycle, distribution channels, signing strategy, repository separation of concerns, and future Continuous Deployment (CD) pipeline for the Offlink project.

---

## 1. Repository Separation of Concerns

Offlink strictly enforces a dual-repository architecture:

```
┌──────────────────────────────────────────────┐
│  Source Repository:                          │
│  https://github.com/Omkar-git-hub/offlink   │
│  - Application source code (Flutter/Dart)    │
│  - Architecture documentation                │
│  - Automated unit, widget & fuzzing tests    │
│  - Development CI workflows                  │
└───────────────────────┬──────────────────────┘
                        │
                        ▼ (CI / CD Pipeline)
┌──────────────────────────────────────────────┐
│  Distribution Repository:                    │
│  https://github.com/Omkar-git-hub/offlink-releases │
│  - Public release notes & announcements     │
│  - GitHub Releases & binary APK distribution │
│  - End-user installation guides              │
│  - Cryptographic verification & checksums    │
│  - F-Droid distribution metadata             │
└──────────────────────────────────────────────┘
```

### Prohibited Actions in Distribution Repository
- Never copy application development source code into the distribution repository.
- Never commit large APK binary files directly into Git tracking (all binaries must be attached as GitHub Release assets).
- Never commit private signing keys, keystores, or credentials.

---

## 2. Signing Identity Strategy & Upgrade Path

### Alpha Stage (Current: `v0.1.0-alpha.1`)
- **Status**: Signed with an initial development/test signing certificate.
- **Rationale**: Enables early distribution, physical device interoperability testing, and validation of Bluetooth Low Energy mesh routing without prematurely baking an unhardened key management setup.
- **Impact**: All users installing `v0.1.0-alpha.1` must uninstall this build prior to installing future production builds signed with the official release key due to Android OS signature identity matching (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`).

### Production Stage (Future Stable Releases)
- **Identity**: A permanent, dedicated 4096-bit RSA or EC production release keystore will be generated.
- **Storage**: Keystore material will be stored securely using air-gapped backup and loaded into GitHub Actions via encrypted repository secrets (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`).
- **Signature Scheme**: APK Signature Scheme v2 and v3.

---

## 3. Future Continuous Deployment (CD) Architecture

The planned automated release pipeline will operate as follows:

```
Main Source Repository (offlink)
  │
  ├─ 1. Maintainer tags release commit: `git tag v0.1.0-alpha.2`
  ├─ 2. Tag push triggers `.github/workflows/release.yml`
  ├─ 3. Automated Verification Gate:
  │      ├─ Secret scanning (Gitleaks)
  │      ├─ Static analysis (`flutter analyze`)
  │      ├─ Test suite pass (`flutter test`)
  │      └─ Build verification (`flutter build apk --release`)
  ├─ 4. APK Signing via Encrypted Secrets
  ├─ 5. Checksum Generation (`sha256sum > SHA256SUMS.txt`)
  ├─ 6. Automated GitHub Release dispatch to `offlink-releases`
  └─ 7. Metadata update in `metadata/release-information.json`
```

---

## 4. Release Classification Guidelines

1. **Alpha Releases (`vX.Y.Z-alpha.N`)**:
   - Released for experimental validation of newly implemented protocols or architectures.
   - May contain experimental UI or subject-to-change APIs.
2. **Beta Releases (`vX.Y.Z-beta.N`)**:
   - Released when all phase milestones are complete and the app is ready for wide-scale peer mesh testing.
   - Requires multi-device physical validation.
3. **General Availability Releases (`vX.Y.Z`)**:
   - Signed with the permanent official key.
   - Accompanied by full documentation and submitted to F-Droid.
