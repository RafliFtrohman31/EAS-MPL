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

// Tambahkan skrip ini di bagian paling bawah file android/build.gradle.kts

// Gantikan blok kode paling bawah Anda dengan skrip tanpa afterEvaluate ini:

subprojects {
    // Karena project sudah di-evaluate, kita bisa langsung mengakses konfigurasinya
    val proj = this
    proj.plugins.withId("com.android.library") {
        val androidExtension = proj.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (androidExtension != null && androidExtension.namespace == null) {
            if (proj.name == "isar_flutter_libs") {
                androidExtension.namespace = "dev.isar.isar_flutter_libs"
            } else {
                androidExtension.namespace = "${proj.group}.${proj.name}".replace("-", "_")
            }
        }
    }
    proj.plugins.withId("com.android.application") {
        val androidExtension = proj.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (androidExtension != null && androidExtension.namespace == null) {
            androidExtension.namespace = "${proj.group}.${proj.name}".replace("-", "_")
        }
    }
}