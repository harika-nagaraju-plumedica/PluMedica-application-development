@echo off
setlocal enabledelayedexpansion

REM Plumedica Flutter Release Build Script
REM This script builds the APK for release, working around AOT compiler issues on Windows

echo.
echo ===============================================
echo Plumedica - Flutter Release Build
echo ===============================================
echo.

REM Clean previous builds
echo Cleaning previous builds...
call flutter clean
call flutter pub get

REM Build for ARM64 (64-bit) architecture
echo.
echo Building release APK for ARM64...
echo This may take 3-5 minutes...
echo.

call flutter build apk --release --target-platform android-arm64

if !errorlevel! equ 0 (
    echo.
    echo ===============================================
    echo BUILD SUCCESSFUL
    echo ===============================================
    echo.
    echo APK location:
    echo   build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo This APK supports:
    echo   - ARM64-v8a devices
    echo   - x86_64 emulators
    echo.
) else (
    echo.
    echo ===============================================
    echo BUILD FAILED
    echo ===============================================
    echo Exit code: !errorlevel!
    exit /b 1
)

endlocal
