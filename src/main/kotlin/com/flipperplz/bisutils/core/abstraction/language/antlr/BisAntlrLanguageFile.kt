package com.flipperplz.bisutils.core.abstraction.language.antlr

import com.flipperplz.bisutils.core.abstraction.language.BisLanguageFile
import com.flipperplz.bisutils.core.io.BisInputStream
import com.flipperplz.bisutils.core.io.BisOutputStream
import org.antlr.v4.runtime.CharStream
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.TokenStream
import kotlin.reflect.full.*
import kotlin.reflect.jvm.javaMethod
import kotlin.reflect.typeOf

@Suppress("UNCHECKED_CAST")
abstract class BisAntlrLanguageFile<
    TreeRoot: BisAntlrLanguageElement<*>
> protected constructor(
    reader: BisInputStream,
    closeReader: Boolean = true
) : BisLanguageFile<TreeRoot>(reader, closeReader) {

    protected inline operator fun <
        reified Parser: org.antlr.v4.runtime.Parser,
        reified Lexer : org.antlr.v4.runtime.Lexer,
        reified Root: TreeRoot
    > invoke(reader: BisInputStream, closeReader: Boolean = true) {
        val text = reader.bufferedReader(languageCharset).use {
            it.readText()
        }
        if(closeReader) reader.close();


        val lexer = (Lexer::class.constructors.firstOrNull {
            it.parameters.count() == 1 &&
            with(it.parameters.first()) {
                this.type == typeOf<CharStream>() &&
                this.name == "input"
            }
        } ?: throw Exception("Failed to instantiate $languageName lexer!")).call(CharStreams.fromString(text))
        val tokens = CommonTokenStream(lexer)
        val parser = (Parser::class.constructors.firstOrNull {
            it.parameters.count() == 1 &&
            with(it.parameters.first()) {
                this.type == typeOf<TokenStream>() &&
                this.name == "input"
            }
        } ?: throw Exception("Failed to instantiate $languageName parser!")).call(tokens)

        val elementAnnotation = Root::class.findAnnotation<BisAntlrLanguageElement.BisAntlrLanguageElementAnnotation>() ?:
        throw Exception("Failed to find BisAntlrLanguageElementAnnotation on root element")

        val rule = elementAnnotation.ruleContext.cast((Parser::class.functions.firstOrNull() {
            it.parameters.isEmpty() &&
                    it.name == elementAnnotation.parserFunctionName &&
                    it.returnType == elementAnnotation.ruleContext
        }?.javaMethod ?: throw Exception("Failed to find ${elementAnnotation.parserFunctionName} function in ${Parser::class.qualifiedName}"))
            .invoke(parser))

        treeRoot = (Root::class.constructors.firstOrNull {
            with(it.parameters) {
                this.count() == 2 &&
                        this.first().type == rule::class.starProjectedType
            }
        } ?: throw Exception("Failed to find a constructor in ${Root::class.qualifiedName}")).call()
    }

    final override val binaryLanguage: Boolean = false;
    final override val implementationType: String = "ANTLR"
}