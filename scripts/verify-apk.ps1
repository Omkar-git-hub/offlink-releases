<#
.SYNOPSIS
    Verifies the SHA-256 file integrity and APK cryptographic signature of Offlink release binaries.

.DESCRIPTION
    Computes the SHA-256 checksum of an Offlink APK, compares it against SHA256SUMS.txt,
    and optionally validates the APK signature scheme and signing certificate using apksigner.

.PARAMETER ApkPath
    Path to the Offlink APK file. If omitted, searches for Offlink-*.apk in current directory.

.PARAMETER ChecksumFile
    Path to SHA256SUMS.txt. Defaults to SHA256SUMS.txt in the same directory as the APK.

.PARAMETER SkipSignature
    If specified, skips apksigner certificate verification.

.EXAMPLE
    .\scripts\verify-apk.ps1
    .\scripts\verify-apk.ps1 -ApkPath .\Offlink-0.1.0-alpha.4.apk
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$ApkPath,

    [Parameter(Position = 1)]
    [string]$ChecksumFile,

    [switch]$SkipSignature
)

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Offlink APK Verification Utility (Windows PowerShell)     " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Resolve APK file
if (-not $ApkPath) {
    $found = Get-ChildItem -Path . -Filter "Offlink-*.apk" -File | Select-Object -First 1
    if (-not $found) {
        $found = Get-ChildItem -Path . -Filter "*.apk" -File | Select-Object -First 1
    }
    if ($found) {
        $ApkPath = $found.FullName
    } else {
        Write-Error "No APK specified and none found in the current directory. Usage: .\verify-apk.ps1 -ApkPath <path-to-apk>"
        exit 1
    }
}

if (-not (Test-Path $ApkPath)) {
    Write-Error "APK file not found: $ApkPath"
    exit 1
}

$apkItem = Get-Item $ApkPath
Write-Host "[*] Target APK : $($apkItem.FullName)" -ForegroundColor White
Write-Host "[*] File Size  : $($apkItem.Length) bytes ($([math]::Round($apkItem.Length / 1MB, 2)) MB)" -ForegroundColor White

# 2. Compute SHA-256
Write-Host "`n--- Step 1: File Integrity Check (SHA-256) ---" -ForegroundColor Yellow
$hashResult = Get-FileHash -Path $ApkPath -Algorithm SHA256
$computedHash = $hashResult.Hash.ToLowerInvariant()
Write-Host "[+] Computed SHA-256 : $computedHash" -ForegroundColor White

# 3. Compare with Checksum file
if (-not $ChecksumFile) {
    $candidateChecksum = Join-Path $apkItem.DirectoryName "SHA256SUMS.txt"
    if (Test-Path $candidateChecksum) {
        $ChecksumFile = $candidateChecksum
    }
}

if ($ChecksumFile -and (Test-Path $ChecksumFile)) {
    Write-Host "[*] Reading Checksum Manifest: $ChecksumFile" -ForegroundColor Gray
    $lines = Get-Content $ChecksumFile
    $expectedHash = $null
    foreach ($line in $lines) {
        if ($line -match "^\s*([a-fA-F0-9]{64})\s+\*?(.+)\s*$") {
            $h = $matches[1].ToLowerInvariant()
            $f = $matches[2].Trim()
            if ($f -eq $apkItem.Name -or $apkItem.Name.EndsWith($f)) {
                $expectedHash = $h
                break
            }
        }
    }

    if ($expectedHash) {
        Write-Host "[+] Expected SHA-256 : $expectedHash" -ForegroundColor White
        if ($computedHash -eq $expectedHash) {
            Write-Host "[SUCCESS] SHA-256 Checksum MATCHES! The APK is intact and untampered." -ForegroundColor Green
        } else {
            Write-Host "[FAILURE] SHA-256 Checksum MISMATCH! Do not install this binary." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "[!] Note: APK filename '$($apkItem.Name)' not found in $ChecksumFile." -ForegroundColor Yellow
    }
} else {
    Write-Host "[!] SHA256SUMS.txt not found. To verify integrity, compare the computed hash with the release page." -ForegroundColor Yellow
}

# 4. Signature Verification (apksigner)
if (-not $SkipSignature) {
    Write-Host "`n--- Step 2: Developer Identity & Signature Check ---" -ForegroundColor Yellow

    # Locate apksigner
    $apksignerCmd = $null
    $inPath = Get-Command "apksigner" -ErrorAction SilentlyContinue
    if ($inPath) {
        $apksignerCmd = $inPath.Source
    } else {
        # Check standard Android SDK locations
        $sdkCandidates = @(
            "$env:LOCALAPPDATA\Android\Sdk\build-tools",
            "$env:ANDROID_HOME\build-tools",
            "$env:ANDROID_SDK_ROOT\build-tools"
        )
        foreach ($sdkDir in $sdkCandidates) {
            if (Test-Path $sdkDir) {
                $latest = Get-ChildItem -Path $sdkDir -Directory | Sort-Object Name -Descending | Select-Object -First 1
                if ($latest) {
                    $bat = Join-Path $latest.FullName "apksigner.bat"
                    if (Test-Path $bat) {
                        $apksignerCmd = $bat
                        break
                    }
                }
            }
        }
    }

    if ($apksignerCmd) {
        Write-Host "[*] Found apksigner at: $apksignerCmd" -ForegroundColor Gray
        try {
            $sigOutput = & $apksignerCmd verify --verbose --print-certs $ApkPath 2>&1
            $sigText = $sigOutput -join "`n"

            if ($sigText -match "Verifies") {
                Write-Host "[SUCCESS] APK signature verifies successfully!" -ForegroundColor Green

                # Extract details
                foreach ($line in $sigOutput) {
                    if ($line -match "Verified using|Signer #|certificate DN|certificate SHA-256") {
                        Write-Host "    $line" -ForegroundColor Cyan
                    }
                }
            } else {
                Write-Host "[FAILURE] APK signature validation failed!" -ForegroundColor Red
                Write-Host $sigText -ForegroundColor DarkRed
                exit 1
            }
        } catch {
            Write-Host "[!] Error executing apksigner: $_" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "[i] apksigner not detected on system PATH or Android SDK." -ForegroundColor Gray
        Write-Host "    To verify signing certificates, install Android SDK build-tools or run:" -ForegroundColor Gray
        Write-Host "    apksigner verify --verbose --print-certs '$($apkItem.Name)'" -ForegroundColor Gray
    }
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host " Verification Process Complete                             " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
