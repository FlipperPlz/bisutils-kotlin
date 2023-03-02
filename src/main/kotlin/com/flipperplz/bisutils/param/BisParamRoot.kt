package com.flipperplz.bisutils.param

import com.flipperplz.bisutils.core.abstraction.language.antlr.BisAntlrLanguageElement
import com.flipperplz.bisutils.core.io.BisOutputStream
import com.flipperplz.bisutils.generated.BisParamParser

class BisParamRoot(
    root: BisParamParser.Param_treeContext,
    languageFile: BisParamLanguageFile
) : BisAntlrLanguageElement<BisParamParser.Param_treeContext>(root, languageFile) {

    override val elementName: String = "ParamFile Root"
    override val elementId: Short = 0;


    override fun write(writer: BisOutputStream, closedWriter: Boolean) {
        TODO("Not yet implemented")
    }

}