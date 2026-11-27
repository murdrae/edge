allprojects {
    repositories {
        google()
        mavenCentral()
    }
    // Pin a single androidx.work version across ALL modules (incl. the workmanager
    // plugin) so no module drags in an older copy (duplicate androidx.work.*Kt
    // classes). workmanager_android 0.10.x compiles against work-runtime 2.11.2 and
    // uses APIs added in 2.9 (ListenableWorker.stopReason, WorkInfo.periodicityInfo),
    // so the pin must be at least that version. work-runtime-ktx is a stub since 2.8.

    configurations.all {
        resolutionStrategy {
            force("androidx.work:work-runtime:2.11.2")
            force("androidx.work:work-runtime-ktx:2.11.2")
        }
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
