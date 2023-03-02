package com.flipperplz.bisutils.language.languages.param

import com.flipperplz.bisutils.language.abstraction.antlr.BisAntlrLanguageFile
import com.flipperplz.bisutils.core.io.BisInputStream
import com.flipperplz.bisutils.generated.BisParamLexer
import com.flipperplz.bisutils.generated.BisParamParser
import org.antlr.v4.runtime.Lexer
import org.antlr.v4.runtime.Parser
import java.nio.charset.Charset
import kotlin.reflect.KClass


class BisParamLanguageFile(
    reader: BisInputStream,
    closeReader: Boolean = true
) : BisAntlrLanguageFile<BisParamRoot>(reader, closeReader) {
    override val defaultParser: KClass<out Parser> = BisParamParser::class
    override val defaultLexer: KClass<out Lexer> = BisParamLexer::class
    override val defaultCharset: Charset = Charsets.UTF_8
    override val defaultLanguage: String = "cpp"

    override fun serialize(): String {
        TODO("Not yet implemented")
    }

}