package com.flipperplz.bisutils.language.abstraction.antlr

import com.flipperplz.bisutils.language.abstraction.BisLanguageFile
import com.flipperplz.bisutils.core.io.BisInputStream
import org.antlr.v4.runtime.CharStream
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.Lexer
import org.antlr.v4.runtime.Parser
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.TokenStream
import kotlin.reflect.KClass
import kotlin.reflect.full.*
import kotlin.reflect.jvm.javaMethod
import kotlin.reflect.typeOf

@Suppress("UNCHECKED_CAST")
abstract class BisAntlrLanguageFile<
    TreeRoot: BisAntlrLanguageElement<*>
> protected constructor(
    reader: BisInputStream,
    closeReader: Boolean = true
) : BisLanguageFile<TreeRoot>() {

    abstract val defaultParser: KClass<out Parser>;
    abstract val defaultLexer: KClass<out Lexer>;

    final override val binaryLanguage: Boolean = false;
    final override val implementationType: String = "ANTLR"

    override fun deserialize(data: String) {

    }


    companion object {

        fun parseStringAs(parserType: KClass<out Parser>,
                        lexerType: KClass<out Lexer>,
                        ruleType: KClass<out ParserRuleContext>,
                        data: String, vararg ruleArguments: Any?
        ): ParserRuleContext {

            val lexer = (lexerType.constructors.firstOrNull {
                it.parameters.count() == 1 &&
                        with(it.parameters.first()) {
                            this.type == typeOf<CharStream>() &&
                                    this.name == "input"
                        }
            } ?: throw Exception("Failed to instantiate lexer ${Lexer::class.qualifiedName}!")).call(CharStreams.fromString(data))
            val tokens = CommonTokenStream(lexer)
            val parser = (parserType.constructors.firstOrNull {
                it.parameters.count() == 1 &&
                        with(it.parameters.first()) {
                            this.type == typeOf<TokenStream>() &&
                                    this.name == "input"
                        }
            } ?: throw Exception("Failed to instantiate parser ${parserType.qualifiedName}!")).call(tokens)

            val plausibleEntryPoint = ((Parser::class.functions.firstOrNull() {
                it.returnType == ruleType &&
                !it.isSuspend &&
                it.parameters.count() == ruleArguments.count()
            } ?: throw Exception("Failed to find a plausible entry point in ${parserType.qualifiedName}!." +
                    "Rule ${ruleType.qualifiedName} with ${ruleArguments.count()} arguments/parameters was not found")).javaMethod) ?:
                    throw Exception("Failed to convert entryPoint to a javaMethod!")

            if(!plausibleEntryPoint.canAccess(parser)) throw Exception("Entry point not accessible!")

            return (ruleType.safeCast(plausibleEntryPoint.invoke(parser, ruleArguments)
                ?: throw Exception("Failed to invoke entry point with arguments ${ruleArguments.toString()}"))
                ?: throw Exception("Failed to cast invocation to ${ruleType.qualifiedName}"))
        }
    }
}