#!/usr/bin/env pwsh
# Plumedica Flutter Optimized Release Build Script
# Target: APK size under 20 MB

[CmdletBinding()]
param()

Write-Host "`n=========================================================`n" -ForegroundColor Cyan
Write-Host "Plumedica - Optimized APK Build (Target: Under 20 MB)`n" -ForegroundColor Cyan
Write-Host "=========================================================`n" -ForegroundColor Cyan

# Step 1: Clean build cache
Write-Host "[Step 1/5] Cleaning build cache..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) { exit 1 }

# Step 2: Get dependencies
Write-Host "[Step 2/5] Downloading dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) { exit 1 }

# Step 3: Analyze code
Write-Host "[Step 3/5] Analyzing code for optimization..." -ForegroundColor Yellow
flutter analyze
# Don't fail on analysis warnings, just continue

# Step 4: Build release APK
Write-Host ""
Write-Host "[Step 4/5] Building optimized release APK..." -ForegroundColor Yellow
Write-Host "Note: This includes code shrinking, obfuscation, and resource optimization" -ForegroundColor Cyan
Write-Host ""

flutter build apk --release --target-platform android-arm64

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n=========================================================`n" -ForegroundColor Red
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Host "=========================================================`n" -ForegroundColor Red
    exit 1
}

# Step 5: Display results
Write-Host ""
Write-Host "=========================================================`n" -ForegroundColor Green
Write-Host "BUILD SUCCESSFUL`n" -ForegroundColor Green
Write-Host "=========================================================`n" -ForegroundColor Green

# Get APK info
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"
if (Test-Path $apkPath) {
    $sizeBytes = (Get-Item $apkPath).Length
    $sizeMB = [math]::Round($sizeBytes / 1MB, 2)
    
    if ($sizeMB -lt 20) {
        Write-Host "[SUCCESS] APK size: $sizeMB MB (Under 20 MB target!)" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] APK size: $sizeMB MB (Above 20 MB target)" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "Output location:" -ForegroundColor Cyan
Write-Host "  $apkPath" -ForegroundColor White
Write-Host ""

Write-Host "Build configuration used:" -ForegroundColor Cyan
Write-Host "  - Architecture: ARM64-v8a" -ForegroundColor White
Write-Host "  - Code Shrinking: ENABLED" -ForegroundColor White
Write-Host "  - Resource Shrinking: ENABLED" -ForegroundColor White
Write-Host "  - Obfuscation: ENABLED (ProGuard)" -ForegroundColor White
Write-Host "  - Minification: ENABLED" -ForegroundColor White
Write-Host "  - Material Icons Tree-Shaking: ENABLED" -ForegroundColor White
Write-Host ""
