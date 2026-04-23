# Plumedica APK Build Guide

## Issue: AOT Compiler Error on Windows (Exit Code -1073741701)

When building a release APK on Windows, you may encounter this error:
```
Dart snapshot generator failed with exit code -1073741701
Target android_aot_release_android-arm failed: Exception: AOT snapshotter exited with code -1073741701
```

This is a known issue with the 32-bit ARM architecture AOT compiler on some Windows systems.

## Solution

The application has been configured to build successfully for **ARM64 (64-bit)** devices.

### Quick Build Methods

#### Option 1: Using PowerShell Script (Recommended)
Run the build script from the project root:
```powershell
.\build-release.ps1
```

#### Option 2: Using Batch Script
```cmd
build-release.bat
```

#### Option 3: Command Line
Build for ARM64 architecture:
```bash
flutter build apk --release --target-platform android-arm64
```

### Build Output
The release APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Supported Architectures

The configured release build supports:
- **ARM64-v8a** (64-bit) - Modern Android devices (Recommended)
- **x86_64** - Android emulators on 64-bit systems

## Architecture Details

| Architecture | Support | Notes |
|---|---|---|
| ARM64-v8a | ✅ Yes | Recommended - 64-bit devices |
| armeabi-v7a | ❌ No | 32-bit ARM (AOT compiler issues) |
| x86_64 | ✅ Yes | Emulator support |
| x86 | ❌ No | 32-bit emulator not supported |

## Why This Issue Occurs

The error code `-1073741701` (0xC000001D - STATUS_ILLEGAL_INSTRUCTION) indicates the Dart AOT compiler is failing on 32-bit ARM architecture compilation on Windows. This is due to:

1. Compiler incompatibility on Windows host
2. Missing or incompatible runtime libraries
3. System architecture mismatch

The 64-bit ARM64 architecture compiles successfully without issues.

## Debug Builds

Debug builds (which use JIT compilation) work fine on all architectures:
```bash
flutter build apk --debug
```

## Gradle Configuration

The build configuration in `android/app/build.gradle.kts` includes:
```kotlin
ndk {
    abiFilters.addAll(listOf("arm64-v8a", "x86_64"))
}
```

This filters the supported architectures to 64-bit only, improving build times and avoiding the AOT compiler issue.

## Troubleshooting

### Still seeing ARM build errors?
1. Run `flutter clean`
2. Delete `.dart_tool` folder
3. Run `flutter pub get`
4. Use the build script: `.\build-release.ps1`

### Need to build for 32-bit devices?
If you must support 32-bit ARM devices, consider:
1. Using a Linux machine with Flutter to build (often more compatible)
2. Using Flutter Docker image for cross-platform builds
3. Upgrading Flutter and Dart SDKs
4. Installing missing Visual C++ runtime libraries on Windows

### Build is slow?
The release build with code optimization and minification can take 3-5 minutes. This is normal.

## Additional Resources

- [Flutter Build APK Documentation](https://flutter.dev/docs/deployment/android)
- [Android ABI Support](https://developer.android.com/ndk/guides/abis)
- [Flutter Windows Build Issues](https://github.com/flutter/flutter/issues?q=aot+windows)
