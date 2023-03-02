package com.flipperplz.bisutils.core.abstraction.language.antlr

import com.flipperplz.bisutils.core.abstraction.language.BisLanguageElement
import com.flipperplz.bisutils.core.abstraction.language.BisLanguageFile
import org.antlr.v4.runtime.ParserRuleContext
import kotlin.reflect.KClass

abstract class BisAntlrLanguageElement<ParseRule: ParserRuleContext> (
    rule: ParseRule,
    languageFile: BisLanguageFile<*>,
) : BisLanguageElement(languageFile) {

    annotation class BisAntlrLanguageElementAnnotation (
        val parserFunctionName: String,
        val ruleContext: KClass<out ParserRuleContext>
    ) {

    }

};