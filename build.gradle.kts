plugins {
    id("org.jetbrains.kotlin.jvm") version "1.7.10"
    id("idea")
    antlr
    `java-library`
}

group = "com.flipperplz.bisutils"
version = "1.0-SNAPSHOT"

sourceSets {
    main {
        antlr.srcDir("src/main/antlr/")
        java.srcDir("generated-src/antlr/main/java")
    }
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:5.9.1")

    antlr("org.antlr:antlr4:4.12.0")

    implementation("org.antlr:antlr4-runtime:4.12.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.4")
    implementation("org.jetbrains.kotlin:kotlin-reflect:1.7.10")
    implementation("commons-io:commons-io:2.11.0")
    implementation("org.jetbrains.kotlin:kotlin-reflect:1.7.10")
}

tasks {
    named("compileKotlin") {
        dependsOn("generateGrammarSource")
    }

    compileKotlin {
        dependsOn(generateGrammarSource)
        kotlinOptions.jvmTarget = "11"
    }

    generateGrammarSource {
        doFirst { clean }

        maxHeapSize = "128m"
        arguments.add("-package")
        arguments.add("com.flipperplz.bisutils.generated")

        outputDirectory = File("generated-src/antlr/main/java/com/flipperplz/bisutils/generated")

        doLast {
            copy {
                from("$outputDirectory/")
                into("src/main/antlr")
                include("**/*Lexer.tokens")
            }
        }
    }

    clean {
        doLast {
            projectDir.listFiles()?.forEach { file ->
                if (file.isFile() && file.name.startsWith("bisutils-jvm") && (file.extension == "iml" || file.extension == "ipr" || file.extension == "iws")) {
                    file.delete()
                }
            }
            file("src/main/gen").deleteRecursively()
            file("generated-src").deleteRecursively()
        }
    }

    named<Test>("test") {
        useJUnitPlatform()
        testLogging.events("passed", "skipped", "failed")
    }
}

idea {
    module.sourceDirs.add(file("generated-src/antlr/main/java"))
}

java.sourceCompatibility = JavaVersion.VERSION_11
java.targetCompatibility = JavaVersion.VERSION_11

