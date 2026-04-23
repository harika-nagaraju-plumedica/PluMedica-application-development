# Plumedica Flutter Release Build Script
# This script builds the APK for release, working around AOT compiler issues on Windows

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Plumedica - Flutter Release Build" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
flutter pub get

# Build for ARM64 (64-bit) architecture
# Note: 32-bit ARM architecture has AOT compiler issues on Windows
Write-Host ""
Write-Host "Building release APK for ARM64 (64-bit)..." -ForegroundColor Green
Write-Host "This may take 3-5 minutes..." -ForegroundColor Yellow
Write-Host ""

flutter build apk --release --target-platform android-arm64

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "✓ BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK location:" -ForegroundColor Cyan
    Write-Host "  build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor White
    Write-Host ""
    Write-Host "APK size: " -ForegroundColor Cyan -NoNewline
    $apkSize = (Get-Item "build/app/outputs/flutter-apk/app-release.apk").Length / 1MB
    Write-Host "{0:F2} MB" -f $apkSize -ForegroundColor White
    Write-Host ""
    Write-Host "This APK is optimized for:" -ForegroundColor Cyan
    Write-Host "  - ARM64-v8a (64bit Android devices)" -ForegroundColor White
    Write-Host "  - x86_64 emulator support" -ForegroundColor White
    Write-Host ""
    Write-Host "For 32-bit emulators, use: flutter build apk --release" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "✗ BUILD FAILED" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}
