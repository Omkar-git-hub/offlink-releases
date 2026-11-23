# Troubleshooting Guide — Offlink Android Application

This guide addresses common questions, error messages, and connectivity challenges when running Offlink.

---

## 1. Installation Issues

### Error: "App not installed" or "Package appears to be corrupt"
- **Cause 1**: An older build signed with a conflicting certificate is already present on the device.
  - **Fix**: Completely uninstall any previous development or test version of Offlink from your device, restart your phone, and install the new APK.
- **Cause 2**: Insufficient device storage space.
  - **Fix**: Free at least 150 MB of device internal storage before installing.
- **Cause 3**: Incompatible Android OS version.
  - **Fix**: Verify your device is running Android 7.0 (API 24) or newer in **Settings** > **About Phone**.

### Blocked by Google Play Protect
- **Symptoms**: Android displays a red or orange warning screen preventing installation.
- **Explanation**: This occurs because Offlink is an open-source alpha pre-release distributed outside Google Play.
- **Fix**: Tap **More details** on the prompt, then tap **Install anyway**.

---

## 2. Peer Discovery & Bluetooth Issues

### Nearby peers do not appear in the discovery list
- **Step 1: Check Bluetooth**: Ensure Bluetooth is toggled on in quick settings on both devices.
- **Step 2: Check Location / Nearby Devices Permission**:
  - On Android 12+: Verify that **Nearby Devices** permission is set to **Allowed**.
  - On Android 11 and older: Verify that **Location** is turned ON and granted to Offlink. (Android requires Location services to be enabled for BLE scanning).
- **Step 3: Distance & Physical Obstacles**: Ensure devices are within 10–20 meters without dense concrete or metal shielding.
- **Step 4: Pull to Refresh**: On the Offlink home screen, pull down on the list to trigger an immediate fresh discovery scan cycle.

### Bluetooth turns off unexpectedly
- Some Android devices cycle the Bluetooth radio when entering aggressive power saving. Set Offlink's battery usage to **Unrestricted** in Android settings.

---

## 3. Message Routing & Delivery Issues

### Message remains in "Pending" status
- **Explanation**: Offlink messages transition from `pending` to `delivered` when an end-to-end cryptographic acknowledgment (ACK) is received from the recipient.
- **Causes**:
  1. The recipient is currently out of direct BLE range and no intermediate mesh relay node is available.
  2. The packet has been enqueued in Offlink's persistent Store-and-Forward queue.
- **Solution**: The message will automatically be delivered and acknowledged as soon as the recipient comes into range or another mesh node relays the packet.

### "Key Mismatch" Warning Banner in Chat
- **Symptoms**: A persistent warning banner indicates *"Security Warning: Peer public key has changed!"*.
- **Explanation**: The peer's node ID was previously associated with a different cryptographic public key. This can indicate:
  1. The peer reinstalled the app or cleared their app storage (generating a new identity keypair).
  2. A potential Man-In-The-Middle (MITM) or node ID spoofing attempt.
- **Action**: Contact the peer through an alternate secure channel to verify their identity. Tap the **Shield** icon to inspect and verify their safety fingerprint.

---

## 4. Background Execution & Relay Issues

### Messages are not relayed when the screen is turned off
- **Cause**: Android OEM battery optimization has terminated the background service.
- **Fix**:
  1. Open Android **Settings** > **Apps** > **Offlink** > **Battery**.
  2. Select **Unrestricted**.
  3. Ensure the Offlink notification *"Offlink mesh service active"* remains visible in your notification shade.
