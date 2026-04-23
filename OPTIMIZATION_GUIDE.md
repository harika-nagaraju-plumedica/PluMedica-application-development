# Plumedica APK Optimization Guide

## Quick Build

Run one of these commands to build an optimized APK under 20 MB:

### Windows (PowerShell)
```powershell
.\build-optimized.ps1
```

### Windows (Command Prompt)
```cmd
build-optimized.bat
```

### Command Line (All Platforms)
```bash
flutter build apk --release --target-platform android-arm64
```

## Optimizations Applied

### 1. **Code Shrinking & Obfuscation**
- ✅ ProGuard/R8 enabled for code minification
- ✅ Dead code removal
- ✅ Class and method obfuscation
- ✅ Aggressive optimization passes

### 2. **Resource Shrinking**
- ✅ Unused resource removal
- ✅ Material Icons tree-shaking (99.3% reduction)
- ✅ Unnecessary metadata exclusion

### 3. **Dependency Cleanup**
- ✅ Removed unused `provider` package
- ✅ Removed unused `ExampleViewModel`
- ✅ Kept only essential `GetX` for state management
- ✅ Simplified navigation controller

### 4. **Architecture Optimization**
- ✅ ARM64-v8a only (64-bit devices)
- ✅ Skipped 32-bit ARM architecture (AOT compiler issues)
- ✅ Optimized for modern Android devices

### 5. **Build Configuration**
- ✅ Code shrinking enabled
- ✅ Resource shrinking enabled
- ✅ ProGuard minification enabled
- ✅ Material Icons tree-shaking enabled

## Expected APK Sizes

| Component | Size Reduction |
|-----------|---|
| Material Icons | 1.6 MB → 10 KB (99.3%) |
| Code Shrinking | ~30-40% reduction |
| Resource Shrinking | ~10-15% reduction |
| **Total APK** | **~17-19 MB** |

## Size Breakdown

Typical APK structure:
```
app-release.apk (17-19 MB)
├── classes.dex                 ~4-5 MB (minified Dart/Kotlin code)
├── lib/arm64-v8a/libflutter.so ~5-6 MB (Flutter engine)
├── res/                         ~2-3 MB (resources, images, fonts)
├── assets/                      ~3-4 MB (Dart snapshots, assets)
├── AndroidManifest.xml          ~10-20 KB
└── classes.dex (Flutter)        ~2-3 MB
```

## Device Compatibility

✅ **Supported**: ARM64-v8a (64-bit Android devices)
- Samsung Galaxy S10+, Note 20, S21 etc.
- Google Pixel 4, 5, 6 etc.
- Most modern Android devices (2016+)

⚠️ **Not Supported**: 32-bit ARM devices
- Older devices (pre-2015)
- Due to Windows AOT compiler limitations

## Verification

After building, check the APK size:
```powershell
Get-Item build/app/outputs/flutter-apk/app-release.apk | Select-Object Length
```

or on Linux/Mac:
```bash
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

## Advanced Options

### For Even Smaller Size (Experimental)
```bash
flutter build apk --release \
  --target-platform android-arm64 \
  --no-tree-shake-icons \
  --split-per-abi
```

### Debug Builds (Not Optimized)
For testing purposes only:
```bash
flutter build apk --debug
```
Output: ~100+ MB (not for distribution)

## Troubleshooting

### Build Fails
1. Clean cache: `flutter clean`
2. Refresh deps: `flutter pub get`
3. Check Java: `java -version` (need JDK 11+)
4. Update Flutter: `flutter upgrade`

### APK Still Large
1. Check for unused dependencies: `flutter pub outdated`
2. Remove unused assets from `assets/` folder
3. Check for large image files
4. Profile app: `flutter build apk --release --analyze-size`

### Installation Issues
Ensure device supports ARM64-v8a architecture:
```bash
adb shell getprop ro.product.cpu.abi
```

Should output: `arm64-v8a`

## Performance Notes

Build time with optimizations:
- First build: ~3-5 minutes
- Subsequent builds: ~2-3 minutes

Runtime performance:
- **No impact** - Obfuscation happens at build time only
- App runs at normal speed
- Slightly faster loading due to smaller size

## Next Steps

1. ✅ Built optimized APK under 20 MB
2. Upload to Play Store / distribution channel
3. Monitor crash reports (obfuscated)
4. Use Play Console to map crash stacks to source code
5. Profile on real devices if needed

## Additional Resources

- [Flutter Build Configuration](https://flutter.dev/docs/deployment/android#build-an-app-bundle)
- [Android App Shrinking](https://developer.android.com/studio/build/shrink-code)
- [Material Design Icons Weight](https://pub.dev/documentation/material_design_icons/latest/)
- [ProGuard/R8 Documentation](https://developer.android.com/studio/build/shrink-code)
