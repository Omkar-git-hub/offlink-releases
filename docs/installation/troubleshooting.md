# Troubleshooting Guide — Offlink Android Application

This guide addresses common error messages, installation blockers, permission hurdles, and radio connectivity issues encountered when running Offlink.

---

## 1. Installation & Package Manager Issues

### Error: "App not installed" / "Package appears to be invalid" / `INSTALL_FAILED_UPDATE_INCOMPATIBLE`
- **Root Cause 1: Signing Key Incompatibility**:
  Android enforces that an existing app can only be updated if the new APK is signed with the identical cryptographic private key as the currently installed package.
  - *Scenario*: Transitioning from an early Alpha development-signed build (`CN=Android Debug`) to an official release-signed build, or updating between disparate builds.
  - *Resolution*:
    1. Backup any vital messages or exported notes if needed.
    2. Completely **uninstall** the existing Offlink app from your device.
    3. Restart your device (clearing Android's package manager cache).
    4. Install the new APK cleanly.
- **Root Cause 2: Insufficient Device Storage**:
  Android requires free internal storage to unpack, compile (ART/AOT), and verify packages. Ensure at least 250 MB of free internal storage.
- **Root Cause 3: Incompatible Architecture or OS**:
  Verify your device is running Android 7.0 (API 24) or newer (**Settings** > **About phone** > **Android version**).

---

### Warning: "Blocked by Play Protect" or "Unrecognized app"
- **Cause**: Offlink is an open-source decentralized application distributed via GitHub Releases and not cataloged through the proprietary Google Play Store.
- **Resolution**:
  1. On the Play Protect dialog, tap **More details** (or **See more**).
  2. Tap **Install anyway**.
  3. (Optional) You can verify the APK's SHA-256 hash against `SHA256SUMS.txt` prior to tapping install to guarantee the binary is untampered.

---

### Cannot Toggle "Install unknown apps"
- **Cause**: Restricted profiles, work profiles, or enterprise device management (MDM) policies.
- **Resolution**:
  - If using a work profile, install Offlink in the personal space.
  - Ensure you are operating under the primary device owner profile.

---

## 2. Peer Discovery & Bluetooth Issues

### Nearby peers do not appear in the discovery list
- **Step 1: Verify Bluetooth Radio**:
  Confirm that Bluetooth is toggled ON in Android settings on **both** devices.
- **Step 2: Check Permission Configuration**:
  - *On Android 12+ (API 31+)*: Ensure **Nearby Devices** permission is set to **Allow**.
  - *On Android 7.0–11 (API 24–30)*: Ensure **Location** is toggled ON in Quick Settings and granted to Offlink. Android's operating system enforces location permission to scan for Bluetooth radios.
- **Step 3: Distance & Physical Environment**:
  Bluetooth Low Energy operates reliably within 10–25 meters line of sight. Metal enclosures, thick reinforced concrete walls, or heavy 2.4 GHz Wi-Fi interference can reduce radio range.
- **Step 4: Bluetooth Stack Reset**:
  If the Android Bluetooth daemon (`bluetoothd`) hangs:
  1. Toggle Bluetooth OFF, wait 5 seconds, and toggle it ON.
  2. If the problem persists, toggle **Airplane Mode** ON and OFF, or reboot the device.
- **Step 5: Pull to Refresh**:
  On the Offlink home screen, pull down on the peer list to trigger an immediate duty-cycle discovery scan.

---

### App crashes on launch or Bluetooth fails to start
- **Cause**: Some older or budget devices lack BLE **Peripheral Advertising** hardware support. Offlink requires both central (scanning) and peripheral (advertising) BLE modes to establish decentralized mesh connections.
- **Check**: Use a hardware inspection utility (such as *AIDA64* or *nRF Connect*) to verify that `Bluetooth Low Energy Peripheral Role` is supported by your device's chipset.

---

## 3. Background Relay & Message Delivery Issues

### Messages are not relayed when the screen is locked
- **Cause**: Android OEM battery managers (e.g. Samsung One UI, Xiaomi MIUI/HyperOS, OnePlus OxygenOS) place background apps into deep sleep and kill foreground services.
- **Resolution**:
  1. Navigate to **Settings** > **Apps** > **Offlink** > **Battery**.
  2. Select **Unrestricted** (or disable "Battery Optimization").
  3. On Xiaomi devices: In **Manage apps** > **Offlink**, enable **Autostart** and set **Battery Saver** to **No restrictions**.
  4. Ensure the persistent notification *"Offlink mesh service active"* is visible in your notification shade.

---

### Messages remain stuck in "Pending" status
- **Explanation**: Offlink transitions message status from `pending` to `delivered` only when an end-to-end cryptographic acknowledgment (ACK) is returned from the recipient.
- **Causes**:
  1. The recipient is currently out of direct BLE radio range and no intermediate mesh relay is within range.
  2. The packet has been enqueued in Offlink's Delay-Tolerant Networking (DTN) queue.
- **Resolution**: The message will automatically be delivered and acknowledged as soon as the recipient comes into radio proximity or another Offlink peer bridges the network.

---

### Warning: "Security Warning: Peer public key has changed!"
- **Symptoms**: A yellow or red warning banner appears at the top of a direct chat.
- **Explanation**: The node ID you are communicating with was previously paired with a different public key. This indicates:
  1. *Benign*: The peer uninstalled and reinstalled Offlink, clearing their local cryptographic identity keys.
  2. *Adversarial*: A potential Man-In-The-Middle (MITM) attack or node impersonation.
- **Resolution**:
  - Contact the peer via an alternative verified channel.
  - In the chat header, tap the **Shield** icon to open the **Safety Fingerprint Dialog**.
  - Compare the 60-digit safety fingerprint on both screens. If they do not match, do not send sensitive messages.

---

## 4. Verification Failures

### SHA-256 Checksum Mismatch
- **Symptoms**: `sha256sum` or `Get-FileHash` yields a digest different from `SHA256SUMS.txt`.
- **Causes**:
  - Network interruption caused an incomplete or truncated download.
  - Browser extension or proxy altered the binary.
- **Resolution**:
  1. Delete the corrupted APK file.
  2. Re-download both `Offlink-<version>.apk` and `SHA256SUMS.txt` from [GitHub Releases](https://github.com/Omkar-git-hub/offlink-releases/releases).
  3. Re-compute the hash. If the checksum continues to fail, report the issue immediately.

---

## 5. Further Assistance

If your issue is not resolved by this guide:
- Check existing issues or submit a bug report at the **[Offlink Source Repository Issue Tracker](https://github.com/Omkar-git-hub/offlink/issues)**.
- For private security concerns, review **[SECURITY.md](../../SECURITY.md)**.
