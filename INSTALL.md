# Installation Guide — Offlink Android Application

This guide provides instructions for downloading, verifying, installing, and configuring the Offlink Android application on your device.

---

## System Requirements

- **Operating System**: Android 7.0 Nougat (API Level 24) or higher (tested through Android 16+).
- **Hardware**: Bluetooth Low Energy (BLE 4.2+) hardware with Peripheral Advertising support.
- **Location Services**: Enabled on Android 11 and older (required by Android OS for BLE discovery).
- **Network Requirements**: None. Offlink operates completely without internet access, cellular data, or SIM cards.
- **Google Services**: None. Offlink contains zero dependencies on Google Play Services or microG.

---

## Step 1: Download the Official Release Assets

Always download Offlink APK binaries exclusively from the official GitHub Releases page:

👉 **[Official Offlink Releases](https://github.com/Omkar-git-hub/offlink-releases/releases)**

On the Releases page, locate your desired release and download both assets:
1. **`Offlink-<version>.apk`**: The compiled Android application package (e.g., `Offlink-0.1.0-alpha.4.apk`).
2. **`SHA256SUMS.txt`**: The checksum manifest containing the official build hash.

---

## Step 2: Verify APK Integrity

Before installing, verify that the downloaded APK was not corrupted during transit and matches the official checksum published in `SHA256SUMS.txt`.

### Windows (PowerShell)
```powershell
Get-FileHash -Path .\Offlink-*.apk -Algorithm SHA256
```

### Linux
```bash
sha256sum Offlink-*.apk
```

### macOS
```bash
shasum -a 256 Offlink-*.apk
```

### Android (via Termux)
```bash
sha256sum Offlink-*.apk
```

Open `SHA256SUMS.txt` and ensure the calculated digest matches the digest listed for your APK. For detailed instructions including cryptographic signature verification using `apksigner`, refer to the **[APK Verification Guide](docs/verification/apk-verification.md)**.

---

## Step 3: Authorize "Install Unknown Apps"

Because Offlink is distributed directly outside the Google Play Store, Android requires user permission to install packages from your web browser or file manager.

### Android 8.0 (API 26) through Android 15+
1. Open your browser or file manager and tap the downloaded APK file.
2. When prompted with *"For your security, your phone is not allowed to install unknown apps from this source"*, tap **Settings**.
3. Toggle ON **Allow from this source**.
4. Return to the installer prompt.

### Android 7.0 / 7.1 (API 24 / 25)
1. Open Android **Settings** > **Security** (or **Lock screen and security**).
2. Enable **Unknown sources**.
3. Confirm the security prompt.

---

## Step 4: Install the Application

1. Open your device's **Downloads** folder or file manager.
2. Tap the downloaded `Offlink-<version>.apk`.
3. In the package installer dialog, tap **Install**.
4. **Google Play Protect Notice**:
   - Google Play Protect may display a dialog stating *"Unrecognized app"* or *"Blocked by Play Protect"*.
   - Tap **More details**.
   - Tap **Install anyway**.
   - *Explanation*: This prompt appears for open-source applications distributed outside the Google Play catalog that have not yet established a Google Play reputation score.

---

## Step 5: Grant Required Android Permissions

When launching Offlink for the first time, grant the necessary permissions required for local mesh operation:

| Permission | Scope | Why It Is Required |
| :--- | :--- | :--- |
| **Nearby Devices / Bluetooth** | `BLUETOOTH_SCAN`, `ADVERTISE`, `CONNECT` | Enables scanning for nearby peers, advertising your node, and maintaining BLE connections without internet. |
| **Location (Foreground)** | `ACCESS_FINE_LOCATION` | Required by Android 11 and older to scan for BLE radios; on modern Android, it is used only when you explicitly share your coordinates. |
| **Notifications** | `POST_NOTIFICATIONS` (Android 13+) | Required to display the foreground service status notification so Android does not kill mesh relays in the background. |

> [!NOTE]
> Offlink adheres to strict privacy-by-design principles. Location coordinates are never transmitted across the network unless you explicitly tap the location sharing action inside a conversation.

---

## Step 6: Initial Setup & Connecting with Peers

1. **Enable Bluetooth**: Toggle Bluetooth ON in Android Settings or Quick Settings on all devices.
2. **Open Offlink**: Launch the app. The home screen automatically begins duty-cycled discovery of nearby Offlink nodes.
3. **Bring Devices in Proximity**: Place two or more devices within Bluetooth range (~10–25 meters).
4. **Initiate Chat**: Tap a discovered peer's name to open a direct messaging session. The app will complete an automated X25519 cryptographic handshake.
5. **Verify Safety Fingerprint**: Tap the **Shield** icon in the chat toolbar. Compare the 60-digit symmetric fingerprint on both screens to verify cryptographic authenticity and detect any potential man-in-the-middle.

---

## Updating Offlink & Upgrading

To update to a newer release:
1. Download the new release APK and `SHA256SUMS.txt` from the [Official Releases Page](https://github.com/Omkar-git-hub/offlink-releases/releases).
2. Verify file integrity.
3. Install the APK over the existing app.

> [!WARNING]
> **Signing Key Compatibility & Clean Reinstall Notice**:
> Android enforces cryptographic signature continuity. You can only perform an in-place update if both APKs were signed with the exact same key.
> - Early Alpha releases are signed with developer testing credentials.
> - When upgrading from an alpha testing build to an official production release (or a build signed with a new key), Android will fail with `INSTALL_FAILED_UPDATE_INCOMPATIBLE`.
> - If this occurs, **backup any important messages, uninstall the previous version from your device, and install the new APK cleanly**.

---

## Related Documentation & Troubleshooting

- **[Detailed Android Installation Guide](docs/installation/android-installation.md)**: Deep dive into Android OS permission versions, OEM battery optimization configurations, and sideloading details.
- **[Troubleshooting Guide](docs/installation/troubleshooting.md)**: Solutions for common installation, Bluetooth scanning, message delivery, and background execution issues.
- **[APK Verification Guide](docs/verification/apk-verification.md)**: Cryptographic checksum and `apksigner` certificate verification.
- **[Release Policy](docs/distribution/release-policy.md)**: Information about release tiers, signing keys, and stability expectations.
