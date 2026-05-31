plugins {
    // 1. Android 插件版本改为 8.11.1 (根据你之前的报错)
    id("com.android.application") version "8.11.1" apply false
    
    // 2. Kotlin 插件版本改为 2.2.20 (根据当前的报错)
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    
    // 3. Flutter 插件不需要写版本号
    id("dev.flutter.flutter-gradle-plugin") apply false
    
    // 4. Firebase 插件保留这个版本
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
