// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
//     id("com.google.gms.google-services")   // ✅ ADD THIS
// }

// android {
//     namespace = "com.example.eirs_fsm"
//     // compileSdk = flutter.compileSdkVersion
//     compileSdk = 36
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_17
//         targetCompatibility = JavaVersion.VERSION_17
//         isCoreLibraryDesugaringEnabled = true   

//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_17.toString()
//     }

//     defaultConfig {
//         applicationId = "com.example.eirs_fsm"
//         // minSdk = flutter.minSdkVersion
//         minSdk = flutter.minSdkVersion
//         // targetSdk = flutter.targetSdkVersion
//         targetSdk = 36
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }

// }
//     androidComponents {
//     onVariants(selector().all()) { variant ->
//         variant.outputs.forEach { output ->
//             output.outputFileName.set("EIRS_FSM-${variant.name}.apk")
//         }
//     }
// }

// dependencies {
//     implementation(platform("com.google.firebase:firebase-bom:32.7.0")) // ✅ FIXED

//     implementation("com.google.firebase:firebase-analytics")
//     implementation("com.google.firebase:firebase-messaging")
//     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")  // ✅ ADD THIS

// }

// flutter {
//     source = "../.."
// }


import com.android.build.gradle.internal.api.BaseVariantOutputImpl

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.eirs_fsm"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.eirs_fsm"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

android.applicationVariants.all {
    val variantName = name
    val variantVersionName = versionName

    outputs.all {
        val output = this as BaseVariantOutputImpl
        output.outputFileName = "EIRS_FSM-$variantVersionName-$variantName.apk"
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
