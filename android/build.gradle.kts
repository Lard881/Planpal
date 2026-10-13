allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force all plugins/subprojects to compile against SDK 36
subprojects {
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            val androidExt = extensions.getByName("android")
            try {
                val compileSdkMethod = androidExt.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                compileSdkMethod.invoke(androidExt, 36)
            } catch (_: Exception) {}
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
