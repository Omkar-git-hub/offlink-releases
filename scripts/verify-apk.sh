#!/usr/bin/env bash
# ==============================================================================
# Offlink APK Verification Utility (Linux & macOS)
# Verifies SHA-256 integrity and checks APK signature with apksigner if present.
# ==============================================================================

set -euo pipefail

APK_PATH="${1:-}"
CHECKSUM_FILE="${2:-}"

echo "============================================================"
echo " Offlink APK Verification Utility (Linux / macOS)           "
echo "============================================================"

# 1. Resolve APK Path
if [ -z "$APK_PATH" ]; then
    FOUND=$(find . -maxdepth 1 -name "Offlink-*.apk" | head -n 1 || true)
    if [ -z "$FOUND" ]; then
        FOUND=$(find . -maxdepth 1 -name "*.apk" | head -n 1 || true)
    fi
    if [ -n "$FOUND" ]; then
        APK_PATH="$FOUND"
    else
        echo "Error: No APK file specified and none found in current directory."
        echo "Usage: ./scripts/verify-apk.sh <path-to-apk> [path-to-checksum-file]"
        exit 1
    fi
fi

if [ ! -f "$APK_PATH" ]; then
    echo "Error: Target APK not found at $APK_PATH"
    exit 1
fi

APK_NAME=$(basename "$APK_PATH")
APK_DIR=$(dirname "$APK_PATH")
echo "[*] Target APK : $APK_PATH"

# 2. Compute SHA-256
echo ""
echo "--- Step 1: File Integrity Check (SHA-256) ---"
if command -v sha256sum >/dev/null 2>&1; then
    COMPUTED_HASH=$(sha256sum "$APK_PATH" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    COMPUTED_HASH=$(shasum -a 256 "$APK_PATH" | awk '{print $1}')
else
    echo "Error: Neither sha256sum nor shasum is installed."
    exit 1
fi

echo "[+] Computed SHA-256 : $COMPUTED_HASH"

# 3. Check against Checksum Manifest
if [ -z "$CHECKSUM_FILE" ]; then
    if [ -f "$APK_DIR/SHA256SUMS.txt" ]; then
        CHECKSUM_FILE="$APK_DIR/SHA256SUMS.txt"
    elif [ -f "./SHA256SUMS.txt" ]; then
        CHECKSUM_FILE="./SHA256SUMS.txt"
    fi
fi

if [ -n "$CHECKSUM_FILE" ] && [ -f "$CHECKSUM_FILE" ]; then
    echo "[*] Reading Checksum Manifest: $CHECKSUM_FILE"
    EXPECTED_HASH=$(grep -F "$APK_NAME" "$CHECKSUM_FILE" | head -n 1 | awk '{print $1}' || true)
    if [ -n "$EXPECTED_HASH" ]; then
        echo "[+] Expected SHA-256 : $EXPECTED_HASH"
        if [ "$COMPUTED_HASH" = "$EXPECTED_HASH" ]; then
            echo "[\033[32mSUCCESS\033[0m] SHA-256 Checksum MATCHES! The APK is intact and untampered."
        else
            echo "[\033[31mFAILURE\033[0m] SHA-256 Checksum MISMATCH! Do not install this binary."
            exit 1
        fi
    else
        echo "[!] Note: APK filename '$APK_NAME' not found in $CHECKSUM_FILE."
    fi
else
    echo "[!] SHA256SUMS.txt not found. Compare the computed hash with the release page."
fi

# 4. Check Signature with apksigner
echo ""
echo "--- Step 2: Developer Identity & Signature Check ---"
APKSIGNER_CMD=""
if command -v apksigner >/dev/null 2>&1; then
    APKSIGNER_CMD="apksigner"
elif [ -n "${ANDROID_HOME:-}" ] && [ -d "$ANDROID_HOME/build-tools" ]; then
    LATEST=$(ls -d "$ANDROID_HOME/build-tools"/* 2>/dev/null | sort -V | tail -n 1 || true)
    if [ -n "$LATEST" ] && [ -x "$LATEST/apksigner" ]; then
        APKSIGNER_CMD="$LATEST/apksigner"
    fi
elif [ -n "${ANDROID_SDK_ROOT:-}" ] && [ -d "$ANDROID_SDK_ROOT/build-tools" ]; then
    LATEST=$(ls -d "$ANDROID_SDK_ROOT/build-tools"/* 2>/dev/null | sort -V | tail -n 1 || true)
    if [ -n "$LATEST" ] && [ -x "$LATEST/apksigner" ]; then
        APKSIGNER_CMD="$LATEST/apksigner"
    fi
fi

if [ -n "$APKSIGNER_CMD" ]; then
    SIG_OUTPUT=$("$APKSIGNER_CMD" verify --verbose --print-certs "$APK_PATH" 2>&1 || true)
    if echo "$SIG_OUTPUT" | grep -q "Verifies"; then
        echo -e "[\033[32mSUCCESS\033[0m] APK signature verifies successfully!"
        echo "$SIG_OUTPUT" | grep -E "Verified using|Signer #|certificate DN|certificate SHA-256" || true
    else
        echo -e "[\033[31mFAILURE\033[0m] APK signature validation failed!"
        echo "$SIG_OUTPUT"
        exit 1
    fi
else
    echo "[i] apksigner not detected on system PATH or Android SDK."
    echo "    To verify signing certificates, run: apksigner verify --verbose --print-certs '$APK_NAME'"
fi

echo ""
echo "============================================================"
echo " Verification Process Complete                             "
echo "============================================================"
