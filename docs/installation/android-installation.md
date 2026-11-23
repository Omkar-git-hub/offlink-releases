# Android Installation & Setup Guide — Offlink

This document provides a detailed walkthrough for installing and configuring Offlink on Android devices, including permission models across Android versions and background execution configuration.

---

## 1. System Requirements

- **Android Version**: Android 7.0 (Nougat, API 24) or newer.
- **Hardware**: Bluetooth Low Energy (BLE 4.2 or 5.x) with peripheral advertising support.
- **Architecture**: Supports 64-bit ARM (`arm64-v8a`), 32-bit ARM (`armeabi-v7a`), and 64-bit x86 (`x86_64`).
- **Dependencies**: No Google Play Services or proprietary microG frameworks required.

---

## 2. Step-by-Step Installation

### Step A: Download the Official APK
1. Visit the [Official Offlink Releases](https://github.com/Omkar-git-hub/offlink-releases/releases/latest).
2. Download `Offlink-0.1.0-alpha.1.apk`.

### Step B: Authorize App Installation (Sideloading)
Android blocks installing apps downloaded outside verified app stores by default.

- **On Android 8.0 (API 26) through Android 15+**:
  1. Open your browser or file manager and tap the downloaded APK.
  2. When prompted *"For your security, your phone is not allowed to install unknown apps from this source"*, tap **Settings**.
  3. Turn on **Allow from this source**.
  4. Return to the installer and tap **Install**.
- **On Android 7.0 / 7.1**:
  1. Open Android **Settings** > **Security**.
  2. Enable **Unknown sources**.

### Step C: Handle Play Protect Warnings
Because this is an early alpha pre-release:
1. Google Play Protect may display a dialog stating *"Blocked by Play Protect"* or *"Unrecognized app"*.
2. Tap **More details**.
3. Tap **Install anyway**.

---

## 3. Permission Model & Privacy Guarantees

Offlink requests only permissions strictly necessary for local peer-to-peer mesh operation:

### Bluetooth & Nearby Devices Permission
- **Android 12+ (API 31+)**:
  - Offlink requests `BLUETOOTH_SCAN` (with `usesPermissionFlags="neverForLocation"`), `BLUETOOTH_ADVERTISE`, and `BLUETOOTH_CONNECT`.
  - Android will display the permission prompt: *"Allow Offlink to find, connect to, and determine the relative position of nearby devices?"*. Tap **Allow**.
- **Android 11 and older (API 24–30)**:
  - Android requires Location permission (`ACCESS_FINE_LOCATION`) to scan for BLE beacons. Offlink uses this strictly for radio discovery and never collects your physical location without explicit user action.

### Foreground Service & Notifications
- Offlink runs an Android foreground service (`OfflinkForegroundService`) of type `connectedDevice`.
- A persistent notification is displayed while the service is active to ensure Android does not kill the process in low-memory situations.
- **Android 13+ (API 33+)**: Offlink requests `POST_NOTIFICATIONS` to display this service status. Tap **Allow**.

---

## 4. Background Execution Configuration (OEM Specific)

Certain Android device manufacturers (e.g. Xiaomi, Huawei, Samsung, OnePlus) aggressively terminate background processes to conserve battery.

To ensure Offlink can relay mesh messages while minimized:
1. Go to **Settings** > **Apps** > **Offlink** > **Battery** (or **App Battery Usage**).
2. Set battery usage to **Unrestricted** (or disable "Battery Optimization" for Offlink).
3. On Xiaomi (MIUI/HyperOS): Set background autostart to **Enabled** and battery saver to **No restrictions**.
4. On Samsung (One UI): Ensure Offlink is not listed under *"Sleeping apps"* or *"Deep sleeping apps"*.

---

## 5. First-Time Setup & Verifying Your Peer Connection

1. Launch **Offlink**.
2. Have a nearby friend launch Offlink on their device.
3. Keep devices within 10–25 meters.
4. The discovered peer will appear on the **Nearby Peers** list.
5. Tap the peer's name to open a direct chat.
6. The two devices will automatically perform an X25519 cryptographic handshake. Once completed, the badge at the top will indicate **Encrypted**.
7. Tap the **Shield** icon in the chat title bar to open the **Safety Fingerprint Dialog**. Compare the 60-digit number on both screens to verify cryptographic authenticity.
