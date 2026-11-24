# Security Policy & Vulnerability Disclosure — Offlink

Security and privacy are foundational principles of the Offlink project. We are committed to maintaining the highest standards of cryptographic integrity, protocol robustness, and user privacy.

This document describes how to report security vulnerabilities responsibly and how official release authenticity is safeguarded.

---

## 1. Reporting a Security Vulnerability

We welcome security audits, cryptographic reviews, and vulnerability reports from independent researchers, developers, and the open-source community.

> [!CAUTION]
> **DO NOT REPORT SECURITY VULNERABILITIES VIA PUBLIC ISSUES**
> Never open a public GitHub issue, discussion thread, or pull request detailing an unpatched vulnerability, cryptographic weakness, or exploitable bug. Public disclosure before a fix is published puts users at risk.

### Private Reporting Channels

Please submit vulnerability disclosures through one of the following confidential channels:

1. **GitHub Security Advisory (Preferred)**:
   Submit a private advisory draft on the main source repository:
   👉 **[Report a Security Advisory Privately](https://github.com/Omkar-git-hub/offlink/security/advisories/new)**

2. **Distribution Repository Advisory**:
   If the vulnerability pertains to release distribution, packaging, or checksums:
   👉 **[Report a Distribution Security Advisory](https://github.com/Omkar-git-hub/offlink-releases/security/advisories/new)**

### What to Include in Your Report
To help us triage and remediate the issue quickly, include:
- A descriptive summary of the vulnerability.
- Affected components (e.g. BLE GATT transport, X25519 key exchange, ChaCha20-Poly1305 encryption, mesh router, SQLite database, Android manifest).
- Step-by-step reproduction instructions or a minimal proof-of-concept (PoC).
- Potential impact on user confidentiality, message integrity, or network availability.
- Suggested remediation or patch (if available).

### Response & Coordinated Disclosure Timeline
- **Initial Acknowledgment**: Within 48 hours of receipt.
- **Triage & Assessment**: Within 7 business days, including confirmation of severity and affected versions.
- **Remediation & Patching**: Fixes are developed privately on an encrypted branch or advisory workspace.
- **Public Disclosure**: Coordinated release with a GitHub Security Advisory and patched release binaries within an agreed disclosure window (typically 30–90 days, or immediately upon patch availability).

---

## 2. Supported Versions

Security updates and patches are provided for the following release streams:

| Release Stream | Status | Security Support |
| :--- | :--- | :--- |
| **Latest Release / Tag** | Active | ✅ Fully supported with prioritized patches |
| **Previous Alpha Pre-Releases** | Deprecated | ❌ Upgrades required; users must migrate to the latest release |

---

## 3. Official Release Verification & Supply Chain Security

To protect against modified binaries, supply chain attacks, and malicious clones:

1. **Official Distribution Channel Only**:
   Download Offlink APK binaries exclusively from the official distribution repository:
   👉 **[https://github.com/Omkar-git-hub/offlink-releases/releases](https://github.com/Omkar-git-hub/offlink-releases/releases)**
2. **File Integrity Verification**:
   Always verify the SHA-256 digest of downloaded binaries against the official `SHA256SUMS.txt` manifest included with each GitHub Release.
3. **Cryptographic Signature Verification**:
   Verify the digital signature of the APK using `apksigner` to ensure the package was signed by the authentic Offlink release identity and has not been tampered with.

For comprehensive verification commands and signature inspection procedures, see the **[APK Verification Guide](docs/verification/apk-verification.md)**.
