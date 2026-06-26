import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Mempertahankan namespace asli proyek Anda
    namespace = "com.example.android_studio"
    
    // Tetap menggunakan SDK 36 agar sinkron dengan shared_preferences_android
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.android_studio"
        minSdk = flutter.minSdkVersion
        
        // Tetap menggunakan target SDK 36 bawaan proyek modern Anda
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 🛠️ DIUBAH: Menggunakan default signing bawaan untuk menghindari error missing storeFile
    signingConfigs {
        // Blok release manual yang meminta key.properties dihapus agar Gradle tidak mogok
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        
        getByName("release") {
            // Memaksa mode rilis menggunakan signing debug bawaan SDK Flutter
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // Mempertahankan konfigurasi pengabaian eror lint palsu dari Workmanager
    lint {
        checkReleaseBuilds = false
        abortOnError = false
        disable.add("Instantiatable")
    }
}

flutter {
    source = "../.."
}