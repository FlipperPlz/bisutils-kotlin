package com.flipperplz.bisutils.language.abstraction.antlr

import com.flipperplz.bisutils.language.abstraction.BisLanguageElement
import org.antlr.v4.runtime.Lexer
import org.antlr.v4.runtime.Parser
import org.antlr.v4.runtime.ParserRuleContext
import kotlin.reflect.KClass

@Suppress("UNCHECKED_CAST")
abstract class BisAntlrLanguageElement<ParseRule: ParserRuleContext> (
    rule: ParseRule,
    languageFile: BisAntlrLanguageFile<*>,
) : BisLanguageElement(languageFile), BisAntlrSerializable {

    abstract val ruleType: KClass<out ParserRuleContext>
    abstract fun parseRule(rule: ParseRule)

    private fun getAntlrLanguageFile() = languageFile as BisAntlrLanguageFile<*>

    override fun deserializeWith(
        parserType: KClass<out Parser>,
        lexerType: KClass<out Lexer>,
        ruleType: KClass<out ParserRuleContext>,
        data: String,
        vararg ruleArguments: Any?
    ) {
        parseRule((BisAntlrLanguageFile.parseStringAs(
            parserType, lexerType, ruleType,
            data, ruleArguments
        ) as? ParseRule) ?: throw Exception("Failed to cast to parse rule"))
    }

    override fun deserialize(data: String) {
        with(getAntlrLanguageFile()) {
            deserializeWith(defaultParser, defaultLexer, ruleType, data)
        }
    }

}