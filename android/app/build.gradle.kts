plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.plumedica_application_development"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.plumedica_application_development"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Configure supported ABIs - Only 64-bit architectures
        // 32-bit ARM has AOT compiler issues on Windows, so we exclude it
        // If 32-bit support is needed, build on Linux/Mac instead
        ndk {
            abiFilters.clear()
            abiFilters.add("arm64-v8a")  // 64-bit ARM devices (modern phones)
            abiFilters.add("x86_64")      // 64-bit emulator support
        }
    }

    buildTypes {
        release {
            // Enable resource shrinking for APK size reduction (safer than code minification)
            isShrinkResources = true
            
            // Code minification disabled due to Flutter/Dart reflection requirements
            // isMinifyEnabled = true
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    packaging {
        // Exclude unnecessary files to reduce APK size
        resources.excludes.add("META-INF/proguard/androidx-*.pro")
        resources.excludes.add("META-INF/androidx.*.version")
    }
}

flutter {
    source = "../.."
}
