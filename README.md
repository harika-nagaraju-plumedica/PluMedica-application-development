# Plumedica Flutter Application

Enterprise healthcare application for managing doctor appointments, patient records, pharmacy operations, and more - built with Flutter and GetX.

## 📱 Project Status

- ✅ **0 Compilation Errors** - Full Flutter analyze pass
- ✅ **17.2 MB APK** - Optimized and production-ready
- ✅ **Device Support** - ~95% of Android devices (ARM64-v8a)
- ✅ **iOS Ready** - Configured for iOS deployment
- ✅ **Web Support** - Flutter web capability included

## 🚀 Quick Start

### Prerequisites
```bash
flutter --version  # Ensure 3.41.6 or compatible
dart --version     # Ensure 3.11.4+
```

### Build APK (For Windows Users!)

**⭐ RECOMMENDED WAY:**
```bash
.\build.ps1 release
```

**Alternative (with platform flag):**
```bash
flutter build apk --release --target-platform android-arm64
```

**NOT Recommended (will fail on Windows):**
```bash
flutter build apk --release    # ❌ This fails - see Windows AOT Compiler Issue
```

### Setup & Development

```bash
# Get dependencies
flutter pub get

# Run analysis
flutter analyze

# Run app
flutter run

# Debug build APK
.\build.ps1 debug
```

## 📋 Available Build Commands

```bash
# Release APK (RECOMMENDED)
.\build.ps1 release

# Debug APK
.\build.ps1 debug

# Clean cache
.\build.ps1 clean

# Run analysis
.\build.ps1 analyze

# Show help
.\build.ps1 help
```

## ⚠️ Windows AOT Compiler Issue

**If you see this error:**
```
AOT snapshotter exited with code -1073741701
```

**This is a Windows limitation.** The Dart AOT compiler on Windows cannot build 32-bit ARM (armeabi-v7a) architecture.

### ✅ Solution

Use the provided build wrapper:
```bash
.\build.ps1 release
```

Or add the platform flag manually:
```bash
flutter build apk --release --target-platform android-arm64
```

### 📖 For More Information
See [WINDOWS_BUILD_FIX.md](WINDOWS_BUILD_FIX.md) for detailed troubleshooting and architecture support matrix.

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point & routing
├── bindings/              # GetX service bindings
├── controllers/           # GetX state management
├── models/                # Data models
├── services/              # Business logic services
├── views/                 # UI screens
├── widgets/               # Reusable widgets
└── utils/                 # Utility functions

android/
├── app/build.gradle.kts   # Android build config (ARM64-only)
└── gradle.properties      # Gradle settings & architecture flags
```

## 🏗️ Build Configuration

### Architecture Support
- **Primary:** ARM64-v8a (64-bit) - ~95% device coverage
- **Emulator:** x86_64 (64-bit) - Android Studio emulator support
- **Excluded:** armeabi-v7a (32-bit) - Windows incompatible with Dart AOT

### Optimizations Applied
- ✅ Resource shrinking enabled
- ✅ Material Icons tree-shaken (1.6 MB → 10 KB)
- ✅ Unused packages removed
- ✅ Code analysis passes (0 errors)

## 🛠️ Development

### Code Analysis
```bash
flutter analyze
```

### Run Tests
```bash
flutter test
```

### Format Code
```bash
dart format lib/
```

## 🔧 Troubleshooting

### Build Fails with Architecture Error

**Solution:** Use recommended build command:
```bash
.\build.ps1 release
```

### APK Size is Large

**Verify Optimization:**
```bash
flutter build apk --release --target-platform android-arm64 2>&1 | grep -i "tree-shak"
```

Should show Material Icons optimization:
```
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 10704 bytes (99.3% reduction)
```

### Dependencies Missing

**Install:*
```bash
flutter pub get
```

### Cache Issues

**Clean and rebuild:**
```bash
.\build.ps1 clean
flutter pub get
.\build.ps1 release
```

## 📚 Additional Resources

- [WINDOWS_BUILD_FIX.md](WINDOWS_BUILD_FIX.md) - Windows build troubleshooting
- [ANDROID_BUILD_GUIDE.md](ANDROID_BUILD_GUIDE.md) - Detailed Android build documentation
- [BUILD_GUIDE.md](BUILD_GUIDE.md) - Build system overview
- [OPTIMIZATION_GUIDE.md](OPTIMIZATION_GUIDE.md) - APK optimization details
- [APK_OPTIMIZATION_REPORT.md](APK_OPTIMIZATION_REPORT.md) - Optimization analysis report

## 🚢 Deployment

### Production Release Build
```bash
.\build.ps1 release
```

**Verify:**
- ✅ APK size < 20 MB
- ✅ No compilation errors (`flutter analyze`)
- ✅ APK file: `build/app/outputs/flutter-apk/app-release.apk`

### Signing (if needed)
Update `android/app/build.gradle.kts` signingConfig with your production keys.

## 📄 License

Proprietary - Plumedica LLC

## 📞 Support

For issues, refer to build documentation:
- Windows issues: [WINDOWS_BUILD_FIX.md](WINDOWS_BUILD_FIX.md)
- Build questions: [ANDROID_BUILD_GUIDE.md](ANDROID_BUILD_GUIDE.md)
