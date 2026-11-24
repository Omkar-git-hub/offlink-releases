# Detailed Android Installation & Setup Guide — Offlink

This document provides a comprehensive technical guide for installing, configuring, and optimizing the Offlink Android application on physical devices, detailing the Android permission model, background service requirements, and device-specific power optimizations.

---

## 1. Hardware & System Requirements

- **Operating System**: Android 7.0 (Nougat, API Level 24) or higher (fully tested through Android 16, API Level 36).
- **Bluetooth Subsystem**: Bluetooth Low Energy (BLE 4.2 or 5.x) hardware supporting **Peripheral Advertising** mode.
- **CPU Architectures**:
  - `arm64-v8a` (modern 64-bit ARM processors)
  - `armeabi-v7a` (legacy 32-bit ARM processors)
  - `x86_64` (64-bit x86 emulators and devices)
- **Zero Cloud Dependencies**: Does not require Google Play Services, Google Mobile Services (GMS), or microG. Fully functional on de-Googled operating systems (e.g., GrapheneOS, LineageOS, CalyxOS, /e/OS).

---

## 2. Step-by-Step Installation Process

### Step A: Download Official Release Assets
1. Open your mobile browser and visit the **[Official Offlink Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)** page.
2. Select the latest available release (or your target version).
3. Download the application binary: `Offlink-<version>.apk`.
4. Download the checksum manifest: `SHA256SUMS.txt`.

### Step B: Verify Download Integrity (Recommended)
Before executing untrusted code on your device, verify the SHA-256 hash:
- Compare the output of `sha256sum Offlink-<version>.apk` (via Termux or your workstation) against `SHA256SUMS.txt`.
- Refer to the **[APK Verification Guide](../verification/apk-verification.md)** for step-by-step instructions.

### Step C: Authorize Sideloading ("Install Unknown Apps")
By default, the Android security subsystem prevents installation of APKs originating from outside curated stores.

- **On Android 8.0 through Android 15+ (API 26+)**:
  1. Locate the downloaded APK in your browser's download manager or in your device's file manager app (e.g., *Files by Google*, *Material Files*).
  2. Tap the file to initiate package parsing.
  3. When the prompt *"For your security, your phone is not allowed to install unknown apps from this source"* appears, tap **Settings**.
  4. Enable the toggle for **Allow from this source**.
  5. Tap the back button to return to the installer prompt and tap **Install**.
- **On Android 7.0 and 7.1 (API 24 / 25)**:
  1. Open Android **Settings** > **Security** (or **Lock screen and security**).
  2. Scroll to the **Device administration** section and enable **Unknown sources**.
  3. Acknowledge the warning prompt, then return to your file manager to install the APK.

### Step D: Google Play Protect Inspection
Because Offlink is an open-source binary distributed independently:
1. Google Play Protect may present an alert: *"Unrecognized app"* or *"Blocked by Play Protect"*.
2. Tap **More details** to expand the hidden options.
3. Tap **Install anyway** to complete the package extraction and registration.

---

## 3. Permission Model & Privacy Guarantees

Offlink requests only permissions strictly necessary to establish peer-to-peer radio meshes.

### Bluetooth & Nearby Devices
- **Android 12+ (API Level 31+)**:
  - `android.permission.BLUETOOTH_SCAN`: Discovers nearby BLE advertisements. Configured with `usesPermissionFlags="neverForLocation"` to assure the Android OS that Bluetooth scanning is not used to infer geographic location.
  - `android.permission.BLUETOOTH_ADVERTISE`: Broadcasts periodic BLE peripheral advertising packets so nearby devices can discover your node.
  - `android.permission.BLUETOOTH_CONNECT`: Establishes and maintains GATT connections with peers.
  - *User Action*: When prompted *"Allow Offlink to find, connect to, and determine the relative position of nearby devices?"*, tap **Allow**.
- **Android 7.0 through Android 11 (API Level 24–30)**:
  - `android.permission.BLUETOOTH` and `android.permission.BLUETOOTH_ADMIN`: Legacy Bluetooth radio access.
  - `android.permission.ACCESS_FINE_LOCATION`: Android OS versions 6.0 through 11 require location permission to scan for Bluetooth beacons. Offlink uses this strictly for radio discovery and never transmits or records location coordinates without explicit user interaction.

### Foreground Service & Notifications
- Offlink initiates an Android foreground service (`OfflinkForegroundService`) configured with the `connectedDevice` type.
- A persistent notification is shown while the mesh radio service is running to prevent the Android Low Memory Killer (LMK) from prematurely reclaiming the background process.
- **Android 13+ (API Level 33+)**: Offlink requests `android.permission.POST_NOTIFICATIONS`. Tap **Allow** so the service notification can be posted.

### Location Sharing (Opt-in)
- Location permissions (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`) are only accessed if you explicitly choose to share your coordinates in a 1-on-1 or group chat.

---

## 4. OEM Battery Optimization & Background Execution

To relay mesh packets and receive offline messages while the screen is off or the app is minimized, prevent your device manufacturer's power manager from killing Offlink.

### Universal Android Settings
1. Go to **Settings** > **Apps** (or **App Management**) > **Offlink**.
2. Tap **Battery** (or **App Battery Usage**).
3. Select **Unrestricted** (or toggle OFF "Manage automatically" / "Battery optimization").

### Manufacturer-Specific Configurations

#### Samsung (One UI)
1. Go to **Settings** > **Battery and device care** > **Battery** > **Background usage limits**.
2. Ensure Offlink is **NOT** listed in *"Sleeping apps"* or *"Deep sleeping apps"*.
3. Add Offlink to **Never sleeping apps**.

#### Xiaomi / Redmi / POCO (MIUI / HyperOS)
1. Go to **Settings** > **Apps** > **Manage apps** > **Offlink**.
2. Enable **Autostart** (allow app to start in the background).
3. Under **Battery Saver**, select **No restrictions**.
4. In the Recent Apps screen, long-press Offlink and tap the **Lock** icon to keep it resident in RAM.

#### OnePlus / OPPO / Realme (OxygenOS / ColorOS)
1. Go to **Settings** > **Battery** > **More battery settings** > **Optimize battery use**.
2. Find Offlink and select **Don't optimize**.
3. Under **App management** > **Offlink** > **Battery usage**, enable **Allow background activity** and **Allow auto-launch**.

#### Google Pixel / Stock Android
1. Go to **Settings** > **Apps** > **Offlink** > **App battery usage**.
2. Select **Unrestricted**.

---

## 5. First-Time Setup & Establishing Peer Connections

1. **Verify Radio Status**: Ensure Bluetooth is toggled ON in Android settings on all participating devices.
2. **Launch Application**: Open Offlink. Discovered nodes running Offlink will automatically populate the **Nearby Peers** list.
3. **Range & Environment**: Direct BLE communication works best within 10–25 meters line of sight. Multi-hop mesh routing enables messages to hop through intermediate nodes to reach out-of-range recipients.
4. **Initiate Encrypted Chat**: Tap a peer. Devices will exchange public keys via an X25519 Diffie-Hellman handshake. When complete, the top bar displays **Encrypted**.
5. **Verify Cryptographic Safety Fingerprint**:
   - In the chat header, tap the **Shield** icon.
   - Compare the 60-digit safety fingerprint displayed on both screens.
   - If the fingerprints match, your direct channel is verified authentic against eavesdropping and MITM attacks.

---

## 6. Updating Offlink

When new versions are published:
1. Download the updated `Offlink-<version>.apk` from [GitHub Releases](https://github.com/Omkar-git-hub/offlink-releases/releases).
2. Sideload the APK over your current installation.
3. If Android reports `INSTALL_FAILED_UPDATE_INCOMPATIBLE`, this indicates a transition across different signing keys (e.g., updating from an early alpha development key to an official release key). You must uninstall the existing app before installing the new build.

For troubleshooting installation failures, review **[Troubleshooting Guide](troubleshooting.md)**.
