# Security Policy & APK Verification — Offlink

Security and privacy are fundamental pillars of the Offlink project. This document describes how users and researchers can verify official Offlink releases, validate cryptographic identities, and report security vulnerabilities responsibly.

---

## Identifying Official Releases

To protect yourself against modified or malicious builds, only download Offlink from official channels:

- **Official Release Repository**: [https://github.com/Omkar-git-hub/offlink-releases](https://github.com/Omkar-git-hub/offlink-releases)
- **Source Code Repository**: [https://github.com/Omkar-git-hub/offlink](https://github.com/Omkar-git-hub/offlink)

Never download Offlink APK binaries from third-party mirrors, unauthorized file sharing websites, or unverified download portals.

---

## Cryptographic Checksums

Every official release includes a corresponding `SHA256SUMS.txt` file containing the SHA-256 cryptographic hashes of all distributed assets.

### Verified Hashes for Release `v0.1.0-alpha.1`

| Asset | SHA-256 Digest |
| :--- | :--- |
| `Offlink-0.1.0-alpha.1.apk` | `e10a26c0fdc8907f50ad59cbff51ca02994506250067484e8b59ccf2ef4239e7` |
| `SHA256SUMS.txt` | `4ca2c8cf02572a85dd06379c448843d9f9f5d230286e062e571b2e8477b51a20` |


---

## Signing Identity & Certificate Transparency

### Current Alpha Release (`v0.1.0-alpha.1`)
For the initial pre-release and architecture verification stage, builds are signed with the development/alpha signing identity:

- **Signer Common Name**: `CN=Android Debug, O=Android, C=US`
- **Certificate SHA-256 Digest**: `df03904dbb6579c665a55f39c53472056048495c004422f0add2153924de06df`
- **Certificate SHA-1 Digest**: `1a4551631d083108a5b34aebd6102e947882652c`
- **Certificate MD5 Digest**: `bff99f89f7b16564b3e1dd1b6acb0b1d`
- **Signature Scheme**: APK Signature Scheme v2

### Verifying Certificate on Your Machine
Using the Android SDK `apksigner` tool:
```bash
apksigner verify --print-certs Offlink-0.1.0-alpha.1.apk
```
Confirm that the certificate SHA-256 digest matches `df03904dbb6579c665a55f39c53472056048495c004422f0add2153924de06df`.

### Transition to Permanent Official Release Key
As outlined in [docs/distribution/release-policy.md](docs/distribution/release-policy.md), Offlink will introduce an air-gapped, permanent official release signing keystore with the launch of the automated Continuous Deployment (CD) pipeline. When upgrading from this alpha build to that release, Android OS signature enforcement will require an initial uninstall and clean reinstall.

---

## Reporting a Vulnerability

We welcome security audits and vulnerability reports from researchers and the open-source community.

If you discover a security vulnerability, flaw in our cryptographic implementation, or privacy issue:

1. **Do not create a public issue**.
2. Submit a private vulnerability report via **GitHub Security Advisories**:
   👉 [Report a Security Advisory on GitHub](https://github.com/Omkar-git-hub/offlink/security/advisories/new)
3. If GitHub Advisories is inaccessible, open a confidential issue labeled `security` on the main source repository:
   👉 [https://github.com/Omkar-git-hub/offlink/issues](https://github.com/Omkar-git-hub/offlink/issues)

### What to Include in Your Report
- A detailed description of the vulnerability.
- Steps to reproduce the issue or proof-of-concept code.
- Affected components (e.g. packet router, crypto handshake, local database).
- Potential impact on user confidentiality, message integrity, or network availability.

We aim to acknowledge reports within 48 hours and work with you on timely disclosure.
