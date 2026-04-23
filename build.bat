@echo off
REM Plumedica Flutter Build Wrapper
REM Forces correct architecture to prevent Windows AOT compiler error

setlocal enabledelayedexpansion

if "%1"=="" (
    echo.
    echo Plumedica Flutter Build Wrapper
    echo.
    echo Usage: build.bat [command] [options]
    echo.
    echo Commands:
    echo   release         - Build optimized release APK (RECOMMENDED)
    echo   debug           - Build debug APK
    echo   clean           - Clean build cache
    echo   analyze         - Run code analysis
    echo.
    echo Examples:
    echo   build.bat release
    echo   build.bat debug
    echo.
    goto :end
)

REM Extract command
set "CMD=%1"
shift

if "%CMD%"=="release" (
    echo Building optimized release APK for arm64...
    call flutter build apk --release --target-platform android-arm64 %*
    goto :end
)

if "%CMD%"=="debug" (
    echo Building debug APK for arm64...
    call flutter build apk --debug --target-platform android-arm64 %*
    goto :end
)

if "%CMD%"=="clean" (
    echo Cleaning build cache...
    call flutter clean
    goto :end
)

if "%CMD%"=="analyze" (
    echo Running code analysis...
    call flutter analyze %*
    goto :end
)

REM If command not recognized, show help
echo Unknown command: %CMD%
echo.
echo Supported commands: release, debug, clean, analyze
echo Try: build.bat
echo.

:end
endlocal
