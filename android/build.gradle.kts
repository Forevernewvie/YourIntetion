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

subprojects {
    plugins.withId("com.android.library") {
        val androidExtension = extensions.findByName("android") ?: return@withId
        val getNamespace = androidExtension.javaClass.methods.firstOrNull {
            it.name == "getNamespace" && it.parameterCount == 0
        } ?: return@withId
        val setNamespace = androidExtension.javaClass.methods.firstOrNull {
            it.name == "setNamespace" && it.parameterCount == 1
        } ?: return@withId

        val namespace = getNamespace.invoke(androidExtension) as? String
        if (!namespace.isNullOrBlank()) {
            return@withId
        }

        val manifestFile = file("src/main/AndroidManifest.xml")
        val manifestNamespace = if (manifestFile.exists()) {
            val manifest = manifestFile.readText()
            Regex("package\\s*=\\s*\"([^\"]+)\"")
                .find(manifest)
                ?.groupValues
                ?.getOrNull(1)
        } else {
            null
        }

        val fallbackNamespace = "com.vibecodingexpert.${name.replace('-', '_')}"
        setNamespace.invoke(androidExtension, manifestNamespace ?: fallbackNamespace)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
