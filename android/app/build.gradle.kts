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

        // Force 64-bit ARM to avoid Windows AOT failures for armeabi-v7a.
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
        
    }

    buildTypes {
        release {
            // Enable resource shrinking for APK size reduction.
            isShrinkResources = true

            // Enable R8 minification for Android/Kotlin bytecode in release.
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    packaging {
        // Exclude unnecessary files to reduce APK size
        resources.excludes.add("META-INF/proguard/androidx-*.pro")
        resources.excludes.add("META-INF/androidx.*.version")

        // Keep only arm64 native libs in final APK.
        jniLibs.excludes.add("**/armeabi-v7a/*.so")
        jniLibs.excludes.add("**/x86_64/*.so")
    }
}

flutter {
    source = "../.."
}
