package com.flipperplz.bisutils.language.abstraction.antlr

import org.antlr.v4.runtime.Lexer
import org.antlr.v4.runtime.Parser
import org.antlr.v4.runtime.ParserRuleContext
import kotlin.reflect.KClass

interface BisAntlrSerializable {
       fun deserializeWith(parserType: KClass<out Parser>, lexerType: KClass<out Lexer>, ruleType: KClass<out ParserRuleContext>, data: String, vararg ruleArguments: Any?)
}