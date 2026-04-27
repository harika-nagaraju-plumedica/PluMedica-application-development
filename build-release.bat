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

if not exist build\symbols mkdir build\symbols
call flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=build/symbols

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
    echo   - Smaller size via R8 + obfuscation
    echo.
    echo Debug symbols: build\symbols
    for %%I in (build\app\outputs\flutter-apk\app-release.apk) do set APK_SIZE_BYTES=%%~zI
    set /a APK_SIZE_MB=!APK_SIZE_BYTES!/1024/1024
    echo APK Size: !APK_SIZE_MB! MB
    if !APK_SIZE_MB! LSS 5 (
        echo APK size check failed: must be between 5 MB and 20 MB
        exit /b 1
    )
    if !APK_SIZE_MB! GTR 20 (
        echo APK size check failed: must be between 5 MB and 20 MB
        exit /b 1
    )
    echo APK size check passed (5-20 MB)
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
