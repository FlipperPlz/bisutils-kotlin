package com.flipperplz.bisutils.core.ast

import org.antlr.v4.runtime.*
import kotlin.reflect.typeOf


inline fun <reified L: Lexer, reified P: Parser> parseString(string: String): BisAntlrCollection<L, P, CommonTokenStream> = with((L::class.constructors.firstOrNull {
    it.parameters.count() == 1 && it.parameters.first().type == typeOf<CharStream>()
} ?: throw Exception("Failed to find default constructor in generated lexer ${L::class.qualifiedName}, maybe there was an update to antlr's code generation?")).call(CharStreams.fromString(string))) {
    val tokens = CommonTokenStream(this)
    return@with BisAntlrCollection(
        this,
        (P::class.constructors.firstOrNull {
            it.parameters.count() == 1 && it.parameters.first().type == typeOf<TokenStream>()
        } ?: throw Exception("Failed to find default constructor in generated parser ${P::class.qualifiedName}, maybe there was an update to antlr's code generation?")).call(tokens),
        tokens)
}


data class BisAntlrCollection<L : Lexer, P : Parser, T : TokenStream>(
    val parser: L,
    val lexer: P,
    val tokens: T
)