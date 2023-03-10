/*
 * This Kotlin source file was generated by the Gradle 'init' task.
 */
package com.flipperplz.bisutils

import com.flipperplz.bisutils.generated.BisEnforceLexer
import com.flipperplz.bisutils.generated.BisEnforceParser
import org.antlr.v4.runtime.*
import kotlin.test.Test
import kotlin.test.assertTrue


class LibraryTest {
    @Test fun `test enforce error-handling for duplicate classnames`() {
        val testCase = """
        class myClass {
                
        }
        
        class myClass {
        
        }
        """.trimIndent()
        val lexer = BisEnforceLexer(CharStreams.fromString(testCase))
        val parser = BisEnforceParser(CommonTokenStream(lexer))

        parser.enforce_tree()
        assertTrue { parser.numberOfSyntaxErrors == 1 }
        return
    }

    @Test fun `test enforce error-handling for modded classes`() {
        val testCase = """
        class myClass {
                
        }
        
        modded class myClass {
        
        }
        """.trimIndent()
        val lexer = BisEnforceLexer(CharStreams.fromString(testCase))
        val parser = BisEnforceParser(CommonTokenStream(lexer))

        parser.enforce_tree()
        assertTrue { parser.numberOfSyntaxErrors == 1 }
        return
    }

    @Test fun `test enforce error-handling for modded enums`() {
        val testCase = """
        enum exampleEnum {
                
        }
        
        enum exampleEnum {
        
        }
        """.trimIndent()
        val lexer = BisEnforceLexer(CharStreams.fromString(testCase))
        val parser = BisEnforceParser(CommonTokenStream(lexer))

        parser.enforce_tree()
        assertTrue { parser.numberOfSyntaxErrors == 1 }
        return
    }

    @Test fun `test enforce error-handling for duplicate enum names`() {
        val testCase = """
        enum exampleEnum {
                
        }
        
        enum exampleEnum {
        
        }
        """.trimIndent()
        val lexer = BisEnforceLexer(CharStreams.fromString(testCase))
        val parser = BisEnforceParser(CommonTokenStream(lexer))

        parser.enforce_tree()
        assertTrue { parser.numberOfSyntaxErrors == 1 }
        return
    }

    @Test fun `test enforce error-handling for global deconstruction`() {
        val testCase = """
        void ~exampleDestructor() {
        
        }
        """.trimIndent()
        val lexer = BisEnforceLexer(CharStreams.fromString(testCase))
        val parser = BisEnforceParser(CommonTokenStream(lexer))

        parser.enforce_tree()
        assertTrue { parser.numberOfSyntaxErrors == 1 }
        return
    }
}
