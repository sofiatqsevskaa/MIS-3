android {
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.mealdb_app"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    implementation("com.google.android.material:material:1.10.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
