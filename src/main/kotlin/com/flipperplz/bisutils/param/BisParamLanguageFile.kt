package com.flipperplz.bisutils.param

import com.flipperplz.bisutils.core.abstraction.language.antlr.BisAntlrLanguageFile
import com.flipperplz.bisutils.core.io.BisInputStream
import java.nio.charset.Charset


class BisParamLanguageFile(reader: BisInputStream
) : BisAntlrLanguageFile<BisParamRoot>(reader) {

    override val defaultCharset: Charset = Charsets.UTF_8;
    override val defaultOptions: Map<String, String?> = mapOf(Pair("charset", "UTF-8"))
    override val languageName: String = "Param Language"

}