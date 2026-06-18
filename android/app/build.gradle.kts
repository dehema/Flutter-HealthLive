import java.nio.file.Files
import java.nio.file.StandardCopyOption

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.healthlive.healthlive_client"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.healthlive.healthlive_client"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Gradle 原生输出：build/app/outputs/apk/release/HealthLive.apk
    applicationVariants.configureEach {
        if (buildType.name == "release") {
            outputs.configureEach {
                (this as com.android.build.gradle.internal.api.BaseVariantOutputImpl).outputFileName =
                    "HealthLive.apk"
            }
        }
    }
}

// Flutter 会把 APK 复制到 flutter-apk/ 并固定命名为 app-release.apk；
// 构建结束后重命名为 HealthLive.apk，并保留 app-release.apk 硬链接供 Flutter CLI 识别。
tasks.register("renameFlutterReleaseApk") {
    doLast {
        val flutterApkDir = layout.buildDirectory.get().asFile.resolve("outputs/flutter-apk")
        val appRelease = flutterApkDir.resolve("app-release.apk")
        val healthLive = flutterApkDir.resolve("HealthLive.apk")
        if (!appRelease.exists()) return@doLast

        Files.move(
            appRelease.toPath(),
            healthLive.toPath(),
            StandardCopyOption.REPLACE_EXISTING,
        )
        try {
            Files.createLink(appRelease.toPath(), healthLive.toPath())
        } catch (_: Exception) {
            Files.copy(
                healthLive.toPath(),
                appRelease.toPath(),
                StandardCopyOption.REPLACE_EXISTING,
            )
        }
    }
}

afterEvaluate {
    tasks.named("assembleRelease") {
        finalizedBy("renameFlutterReleaseApk")
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
