# Installation Guide — Offlink Android Application

This guide provides instructions for downloading, verifying, installing, and configuring the Offlink Android application on your device.

---

## System Requirements

- **Operating System**: Android 7.0 Nougat (API Level 24) or higher.
- **Hardware**: Bluetooth Low Energy (BLE 4.2+) hardware with Peripheral Advertising support.
- **Location Services**: Enabled (required by Android OS for BLE discovery).
- **Network Requirements**: None. Offlink does not require internet access, cellular data, or a SIM card.

---

## Step 1: Download the Official APK

Always download Offlink APK binaries exclusively from the official release page:
👉 **[Official Offlink Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)**

Download both:
1. `Offlink-<version>.apk` (e.g. `Offlink-0.1.0-alpha.1.apk`)
2. `SHA256SUMS.txt`

---

## Step 2: Verify APK Integrity

Before installing, verify that the downloaded APK matches the official build checksum.

### On Android (using Termux)
```bash
sha256sum Offlink-0.1.0-alpha.1.apk
```

### On Windows (PowerShell)
```powershell
Get-FileHash -Path .\Offlink-0.1.0-alpha.1.apk -Algorithm SHA256
```

### On macOS / Linux
```bash
sha256sum Offlink-0.1.0-alpha.1.apk
```

Confirm that the output matches:
```text
e10a26c0fdc8907f50ad59cbff51ca02994506250067484e8b59ccf2ef4239e7
```

---

## Step 3: Enable "Install Unknown Apps"

Because Offlink is distributed directly outside the Google Play Store, Android requires you to authorize the app installer.

1. Open Android **Settings** on your device.
2. Navigate to **Apps** > **Special App Access** > **Install Unknown Apps** (or search for "Unknown apps" in Settings).
3. Select the app you used to download the APK (e.g., *Chrome*, *Firefox*, or *Files by Google*).
4. Toggle on **Allow from this source**.

---

## Step 4: Install the Application

1. Open your device's **Downloads** folder or file manager.
2. Tap `Offlink-0.1.0-alpha.1.apk`.
3. In the installation prompt, tap **Install**.
4. If prompted by **Google Play Protect**:
   - Play Protect may display a warning such as *"Unrecognized app"* or *"Blocked by Play Protect"*.
   - Tap **More details** and select **Install anyway**. This warning appears because this is a community alpha release not yet cataloged on Google Play.

---

## Step 5: Grant Required Android Permissions

When launching Offlink for the first time, the application will request permissions essential for offline peer-to-peer communication:

| Permission | Purpose | Why It Is Required |
| :--- | :--- | :--- |
| **Nearby Devices / Bluetooth** | BLE Scan & Connect | Discovers nearby Offlink peers and maintains mesh connections without internet. |
| **Location (Foreground)** | BLE Radio Access & Location Sharing | Required by Android to scan for Bluetooth devices; also used if you choose to share your coordinates. |
| **Notifications** | Background Relay Service | Keeps the Bluetooth foreground service active so your device can relay messages while minimized. |

> [!NOTE]
> Offlink strictly adheres to the principle of minimal data collection. Location data is never transmitted across the network unless you explicitly initiate a location-sharing action within a chat.

---

## Step 6: Initial Setup & Connecting with Peers

1. **Enable Bluetooth**: Ensure Bluetooth is turned on in Android system settings.
2. **Open Offlink**: Launch the app. The home screen displays nearby discovered Offlink peers.
3. **Bring Devices in Proximity**: Bring two devices with Offlink running within BLE radio range (~10–30 meters).
4. **Initiate Chat**: Tap a discovered peer to open a direct chat. An automated X25519 cryptographic handshake will establish an encrypted session.
5. **Verify Safety Fingerprint**: In the chat screen, tap the **Shield** icon to view the 60-digit safety fingerprint and compare it with your peer's screen to ensure no man-in-the-middle exists.

---

## Updating Offlink

To update to future releases:
1. Download the new release APK from [offlink-releases](https://github.com/Omkar-git-hub/offlink-releases/releases).
2. Install the new APK over the existing installation.

> [!WARNING]
> **Alpha to Production Signing Upgrade Notice**:
> The `v0.1.0-alpha.1` build is signed with a testing/alpha certificate. When the permanent production signing key is deployed in a future release, Android will reject an in-place upgrade due to signature incompatibility. You will need to uninstall the alpha version before installing the production build. Ensure you backup any necessary messages before uninstalling.

---

## Troubleshooting

For solutions to common installation issues (such as *"App not installed"*, *"Package appears to be invalid"*, or Bluetooth scanning issues), see [Troubleshooting Guide](docs/installation/troubleshooting.md).
