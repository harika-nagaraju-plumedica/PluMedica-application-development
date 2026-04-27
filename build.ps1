# Plumedica Flutter Build Wrapper Script (PowerShell)
# Forces correct architecture to prevent Windows AOT compiler error
# Usage: .\build.ps1 release|debug|clean|analyze

param(
    [string]$Command = "",
    [string[]]$AdditionalArgs = @()
)

function Show-Help {
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "PLUMEDICA BUILD WRAPPER" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Fixes Windows AOT compiler issue with 32-bit ARM architecture"
    Write-Host ""
    Write-Host "Usage: .\build.ps1 [command] [options]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  release         - Build optimized release APK (RECOMMENDED)"
    Write-Host "  debug           - Build debug APK"
    Write-Host "  clean           - Clean build cache"
    Write-Host "  analyze         - Run code analysis"
    Write-Host "  help            - Show this message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\build.ps1 release"
    Write-Host "  .\build.ps1 debug"
    Write-Host "  .\build.ps1 clean"
    Write-Host ""
}

function Get-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
}

# Main script logic
$cmd = $Command.ToLower()

if ($cmd -eq "release") {
    Get-Header "Building RELEASE APK (arm64-v8a)"
    Write-Host "Platform: ARM64 (64-bit, Windows compatible)"
    Write-Host "Optimizations: R8 shrink + obfuscation + split debug info"
    Write-Host ""

    if (!(Test-Path "build/symbols")) {
        New-Item -ItemType Directory -Path "build/symbols" | Out-Null
    }
    
    & flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=build/symbols @AdditionalArgs
    if ($LASTEXITCODE -eq 0) {
        Get-Header "BUILD SUCCESSFUL"
        Write-Host "APK Location: build\app\outputs\flutter-apk\app-release.apk"
        Write-Host "Debug symbols: build\symbols"
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
        if (Test-Path $apkPath) {
            $size = (Get-Item $apkPath).Length / 1MB
            Write-Host "APK Size: $([math]::Round($size, 1)) MB"
            if ($size -lt 5 -or $size -gt 20) {
                Write-Host "APK size must be between 5 MB and 20 MB" -ForegroundColor Red
                exit 1
            }
            Write-Host "APK size check passed (5-20 MB)" -ForegroundColor Green
        }
        Write-Host ""
    }
    else {
        Write-Host "BUILD FAILED" -ForegroundColor Red
        Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
}
elseif ($cmd -eq "debug") {
    Get-Header "Building DEBUG APK (arm64-v8a)"
    Write-Host "Platform: ARM64 (64-bit, Windows compatible)"
    Write-Host ""
    
    & flutter build apk --debug --target-platform android-arm64 @AdditionalArgs
    if ($LASTEXITCODE -eq 0) {
        Get-Header "BUILD SUCCESSFUL"
        Write-Host "APK Location: build\app\outputs\flutter-apk\app-debug.apk"
        $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
        if (Test-Path $apkPath) {
            $size = (Get-Item $apkPath).Length / 1MB
            Write-Host "APK Size: $([math]::Round($size, 1)) MB"
        }
        Write-Host ""
    }
    else {
        Write-Host "BUILD FAILED" -ForegroundColor Red
        Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
}
elseif ($cmd -eq "clean") {
    Get-Header "Cleaning build cache"
    & flutter clean
    Write-Host "Clean complete" -ForegroundColor Green
    Write-Host ""
}
elseif ($cmd -eq "analyze") {
    Get-Header "Running code analysis"
    & flutter analyze @AdditionalArgs
}
elseif ($cmd -eq "help" -or $cmd -eq "") {
    Show-Help
}
else {
    Write-Host ""
    Write-Host "Unknown command: $Command" -ForegroundColor Red
    Write-Host ""
    Write-Host "Supported commands: release, debug, clean, analyze, help"
    Write-Host 'Try: .\build.ps1 help'
    Write-Host ""
    exit 1
}
