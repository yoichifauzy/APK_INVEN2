plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.inventory_frontend"

    // Compile against Android SDK 36 to match plugins
    compileSdk = 36
    // Biarkan build tools dipilih otomatis oleh AGP

    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.inventory_frontend"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Pakai keystore debug bawaan untuk sementara
            signingConfig = signingConfigs.getByName("debug")

            // Matikan shrink/minify supaya R8 tidak dijalankan,
            // menghindari error "Missing classes" dari anotasi pihak ketiga.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
