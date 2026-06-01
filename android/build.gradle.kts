plugins {
    // 1. Android AGP version
    id("com.android.application") version "8.11.1" apply false
    
    // 2. Kotlin version
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    
    // 3. Flutter plugin
    id("dev.flutter.flutter-gradle-plugin") apply false
    
    // 4. Firebase plugin
    id("com.google.gms.google-services") version "4.4.1" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
