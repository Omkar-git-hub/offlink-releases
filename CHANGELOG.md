# Changelog

All notable changes to the Offlink Android application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.0-alpha.4] - 2026-11-23

### Security Hardening
- **Enforce Fail-Closed Release Signing**: Configured Gradle release build tasks to fail-closed if required signing credentials (`OFFLINK_KEYSTORE_PATH`, `OFFLINK_KEYSTORE_PASSWORD`, `OFFLINK_KEY_ALIAS`, `OFFLINK_KEY_PASSWORD`) are missing or invalid, preventing silent fallback to debug signing.
- **Package Identity Alignment**: Aligned namespace and application ID configuration to `io.github.omkar_git_hub.offlink`.

### Release Notes
- GitHub Release: [`v0.1.0-alpha.4`](https://github.com/Omkar-git-hub/offlink-releases/releases/tag/v0.1.0-alpha.4)
- Target SDK: 36 (Android 16), Minimum SDK: 24 (Android 7.0)

---

## [0.1.0-alpha.1] - 2026-11-23

### Initial Public Alpha Release

This is the initial pre-release deployment of Offlink, marking the completion of Phase 0 through Phase 8 of development. All core peer-to-peer protocols, encrypted messaging services, offline mesh networking, and abuse controls have been verified with 100% test coverage (324/324 passing tests).

### Added
- **Bluetooth Low Energy Engine (Modules 1 & 2)**:
  - BLE discovery and concurrent peripheral advertising without internet.
  - GATT client and server architecture with MTU negotiation and packet chunking.
  - Reactive peer discovery streams on `HomePage`.
- **Cryptographic Security Layer (Module 3)**:
  - X25519 ephemeral key exchange and Ed25519 device identity keys.
  - ChaCha20-Poly1305 authenticated encryption with associated data (AEAD) bound to packet headers.
  - Secure hardware-backed identity storage using Android Keystore / `flutter_secure_storage`.
- **Encrypted Local Persistence (Module 4)**:
  - Drift (SQLite) local database (`OfflinkDatabase`) storing conversations, messages, and peer state.
  - Message lifecycle state machine: `pending`, `sent`, `delivered`, `failed`.
- **Application-Layer Mesh Routing (Module 5)**:
  - Multi-hop store-and-forward mesh packet router (`MeshPacketRouter`).
  - Hop limits, deduplication cache, and loop suppression.
  - Ciphertext-only relaying: intermediate nodes forward encrypted packets without access to plaintext content.
- **Background Service & Lifecycle Resilience (Module 6)**:
  - Android foreground service (`OfflinkForegroundService`) with notification channel and `connectedDevice` type.
  - Automatic connection recovery coordinator with exponential backoff and jitter.
- **Offline Queue & Store-and-Forward DTN (Module 7)**:
  - Persistent queue for unacknowledged packets.
  - Multi-hop ACK recovery and duplicate message suppression.
  - In-transit packet relay storage for disconnected nodes.
- **Decentralized Group Messaging (Module 8)**:
  - Serverless group creation and membership tracking.
  - Encrypted pairwise fanout routing for group messages.
  - Group chat UI with member management sheet (`GroupChatPage`).
- **Privacy-Preserving Location Sharing (Module 9)**:
  - Explicit user-initiated one-time coordinate snapshots.
  - Time-bounded live location sharing sessions (15m, 1h, 8h).
  - In-place deterministic message updating (`loc-live-${id}`) to prevent SQLite database bloat.
  - Pairwise encrypted group location sharing.
- **Battery Optimization & Adaptive BLE Operation (Module 10)**:
  - Duty-cycled BLE discovery with adaptive scan/pause windows (reducing scan radio energy consumption by 33% to 94%).
  - Elimination of unconditional periodic timers (zero idle CPU wakeups).
  - Reconnection storm prevention via inter-peer attempt spacing (500ms).
  - Mesh broadcast loop suppression (skipping echo to sender).
- **Security Hardening & Abuse Controls (Module 11)**:
  - Local serverless peer blocking (`BlockedPeersTable`, `PeerSecurityRepository`).
  - Ingress filtering dropping blocked node packets before decryption or SQLite writes.
  - Inbound sliding-window flood rate limiting (`FloodRateLimiter`: 15 pkts / 3s) with escalating 30-second quarantine backoff.
  - Deterministic symmetric 60-digit SHA-256 safety fingerprints (`SafetyFingerprintGenerator`).
  - Automated MITM key mismatch detection and chat warning banners.
  - Comprehensive protocol fuzzing test suite verifying resistance to malformed/oversized frames.

### Security Notes
- Signed with development/alpha signing certificate for early testing.
- Target SDK: 36 (Android 16), Minimum SDK: 24 (Android 7.0).

### Known Limitations
- Background operation may require disabling aggressive OEM battery optimization on select devices (e.g., Xiaomi MIUI, Samsung One UI).
- Sideloading requires manual permission authorization in Android settings.
