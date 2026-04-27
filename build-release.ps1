# Plumedica Flutter Release Build Script
# Builds a small release APK on Windows and enforces size gate (5-20 MB).

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Plumedica - Flutter Release Build" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
flutter pub get

Write-Host ""
Write-Host "Building release APK for ARM64..." -ForegroundColor Green
Write-Host "This may take 3-5 minutes..." -ForegroundColor Yellow
Write-Host ""

if (!(Test-Path "build/symbols")) {
    New-Item -ItemType Directory -Path "build/symbols" | Out-Null
}

flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=build/symbols

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

$apkPath = "build/app/outputs/flutter-apk/app-release.apk"
if (!(Test-Path $apkPath)) {
    Write-Host "Expected APK not found: $apkPath" -ForegroundColor Red
    exit 1
}

$apkSize = (Get-Item $apkPath).Length / 1MB

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host "APK location: $apkPath" -ForegroundColor Cyan
Write-Host (("APK size: {0:F2} MB" -f $apkSize)) -ForegroundColor White

if ($apkSize -lt 5 -or $apkSize -gt 20) {
    Write-Host "APK size check failed: must be between 5 MB and 20 MB" -ForegroundColor Red
    Write-Host (("Actual size: {0:F2} MB" -f $apkSize)) -ForegroundColor Red
    exit 1
}

Write-Host "APK size check passed (5-20 MB)" -ForegroundColor Green
Write-Host "Debug symbols saved to: build/symbols" -ForegroundColor Yellow
