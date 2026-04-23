# Plumedica Android Build Configuration Guide

## ⚠️ IMPORTANT: Windows AOT Compiler Issue

When building APKs on **Windows**, the Dart AOT compiler fails on 32-bit ARM architecture with error code **-1073741701** (STATUS_ILLEGAL_INSTRUCTION).

### Error Message
```
Dart snapshot generator failed with exit code -1073741701
Target android_aot_release_android-arm failed: Exception: AOT snapshotter exited with code -1073741701
```

---

## ✅ Solution: Always Use Correct Platform Flag

### Correct Way (✅ WORKS)
```bash
flutter build apk --release --target-platform android-arm64
```

### Wrong Way (❌ FAILS)
```bash
flutter build apk --release
```

---

## 🔧 Why This Happens

1. **Default Flutter Build**: When no platform is specified, Flutter tries to build for multiple architectures:
   - `armeabi-v7a` (32-bit ARM) ← **FAILS on Windows with AOT compiler error**
   - `arm64-v8a` (64-bit ARM) ← Works fine
   - `x86` (32-bit emulator) ← Not needed
   - `x86_64` (64-bit emulator) ← Works fine

2. **The Problem**: Windows AOT compiler cannot compile 32-bit ARM code

3. **The Solution**: We've configured gradle to only build 64-bit architectures

---

## 📱 Supported Architectures

| Architecture | Support | Status | Note |
|---|---|---|---|
| arm64-v8a | ✅ YES | **RECOMMENDED** | Modern 64-bit Android devices |
| x86_64 | ✅ YES | Optional | 64-bit Android emulator |
| armeabi-v7a | ❌ NO | FAILS | 32-bit ARM - AOT compiler issue on Windows |
| x86 | ❌ NO | Unused | 32-bit emulator - deprecated |

---

## 🚀 How to Build

### Option 1: Use Build Script (Recommended)
```bash
.\build-optimized.bat     # Windows
./build-optimized.ps1     # PowerShell
```

### Option 2: Command Line
```bash
flutter build apk --release --target-platform android-arm64
```

### Option 3: Visual Studio Code
Edit `.vscode/launch.json` to include the flag:
```json
{
    "name": "Flutter Release Build",
    "request": "launch",
    "type": "dart",
    "args": ["build", "apk", "--release", "--target-platform", "android-arm64"]
}
```

---

## 🔍 gradle Configuration

The `android/app/build.gradle.kts` has been configured to:

1. **Clear default ABI filters** to prevent ambiguity
2. **Explicitly set** only 64-bit architectures
3. **Add comments** explaining why

```kotlin
ndk {
    abiFilters.clear()
    abiFilters.add("arm64-v8a")  // 64-bit ARM devices
    abiFilters.add("x86_64")      // 64-bit emulator
}
```

This configuration means:
- ✅ `flutter build apk --release --target-platform android-arm64` **WORKS**
- ❌ `flutter build apk --release` **MAY STILL FAIL** (depends on Flutter's override)

---

## ⚠️ If Error Still Occurs

**Even with configuration, if you see the AOT error:**

### Step 1: Clean Everything
```bash
flutter clean
rm -rf android/.gradle
rm -rf build/
```

### Step 2: Rebuild with Platform Flag
```bash
flutter pub get
flutter build apk --release --target-platform android-arm64
```

### Step 3: If Still Fails
1. **On Windows**: Cannot build 32-bit ARM - use Linux/Mac instead
2. **Update Flutter**: `flutter upgrade`
3. **Check Java**: `java -version` (need JDK 11+)

---

## 📊 Device Compatibility

### Target Users (✅ Supported)
- ~95% of active Android devices
- All devices from last 5+ years
- Modern smartphones and tablets

### Unsupported Devices (❌)
- Very old devices (pre-2015)
- Devices with only 32-bit ARM support
- < 2% of active Android devices

---

## 🌍 Building for 32-bit ARM Support

If you absolutely need 32-bit ARM support:

**Option 1**: Build on Linux/Mac
- The AOT compiler works fine on non-Windows systems
- Builds 32-bit ARM without issues

**Option 2**: Use App Bundle
```bash
flutter build appbundle --release --target-platform android-arm64
```
Google Play will generate 32-bit APKs if needed when distributing to older devices.

---

## 📝 Build Success Checklist

- [ ] Using `--target-platform android-arm64` flag
- [ ] gradle.kts has ABI filters properly set
- [ ] `flutter clean` before new build
- [ ] No AOT compiler errors
- [ ] APK size under 20 MB
- [ ] APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔗 References

- [Flutter Build Documentation](https://flutter.dev/docs/deployment/android)
- [Android ABI Architecture](https://developer.android.com/ndk/guides/abis)
- [Flutter AOT Compilation](https://github.com/flutter/flutter/wiki/Troubleshooting)
- [Windows Build Issues](https://github.com/flutter/flutter/issues?q=windows+aot)

---

## 💡 Quick Reference

| Task | Command |
|------|---------|
| Build Release APK | `flutter build apk --release --target-platform android-arm64` |
| Build Optimized | `.\build-optimized.bat` |
| Clean Cache | `flutter clean && flutter pub get` |
| Check Errors | `flutter analyze` |
| Test Size | `powershell "(Get-Item 'build/app/outputs/flutter-apk/app-release.apk').Length/1MB"` |

---

**Last Updated**: April 21, 2026
**Status**: ✅ VERIFIED & WORKING
