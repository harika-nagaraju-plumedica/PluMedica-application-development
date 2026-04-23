@echo off
setlocal enabledelayedexpansion

REM =========================================================
REM Plumedica Flutter Optimized Release Build (< 20 MB)
REM =========================================================

echo.
echo =========================================================
echo Plumedica - Optimized APK Build (Target: Under 20 MB)
echo =========================================================
echo.

REM Step 1: Clean build cache
echo [Step 1/4] Cleaning build cache...
call flutter clean
if !errorlevel! neq 0 goto :error

REM Step 2: Get dependencies
echo [Step 2/4] Downloading dependencies...
call flutter pub get
if !errorlevel! neq 0 goto :error

REM Step 3: Build release APK (ARM64 only)
echo.
echo [Step 3/4] Building optimized release APK for ARM64...
echo Note: Building for 64-bit ARM architecture only
echo.

call flutter build apk --release --target-platform android-arm64

if !errorlevel! neq 0 goto :error

REM Step 4: Display results
echo.
echo =========================================================
echo BUILD SUCCESSFUL
echo =========================================================
echo.

REM Get APK size
for /F %%A in ('powershell -NoProfile -Command "[math]::Round((Get-Item 'build\app\outputs\flutter-apk\app-release.apk').Length / 1MB, 2)"') do (
    if %%A LSS 20 (
        echo [SUCCESS] APK size: %%A MB - UNDER 20 MB TARGET!
    ) else (
        echo [WARNING] APK size: %%A MB - ABOVE 20 MB target
    )
)

echo.
echo Output location:
echo   build\app\outputs\flutter-apk\app-release.apk
echo.

goto :end

:error
echo.
echo =========================================================
echo BUILD FAILED
echo =========================================================
echo.
echo Exit code: !errorlevel!
echo.
echo SOLUTION:
echo   This error occurs when building for 32-bit ARM on Windows
echo   The gradle configuration should prevent this, but if it occurs:
echo   1. Run: flutter clean
echo   2. Run: flutter pub get
echo   3. Make sure you use: --target-platform android-arm64
echo.
exit /b 1

:end
endlocal

