# ProGuard rules for Plumedica Flutter app
# Keep Flutter and Dart runtime classes

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep Flutter plugins
-keep class * implements io.flutter.embedding.engine.FlutterPlugin { *; }

# Dart Runtime
-keep class com.android.system.** { *; }
-keep class dalvik.system.** { *; }

# Keep ViewModels
-keepclasseswithmembernames class * extends androidx.lifecycle.ViewModel { *; }

# Keep all Dart classes needed by reflection
-keepclasseswithmembers class * {
  native <methods>;
}

# Keep annotations
-keepattributes *Annotation*,EnclosingMethod,Signature,InnerClasses,LineNumberTable,SourceFile

# Keep BuildConfig
-keep class com.example.plumedica_application_development.BuildConfig { *; }

# Keep all model classes
-keep class com.example.plumedica_application_development.models.** { *; }

# Optional Google Play Services classes (may not be present)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep all R classes to preserve enumerations
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Optimize aggressive
-optimizationpasses 5
-allowaccessmodification

# Obfuscate but keep meaningful names for debugging
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

