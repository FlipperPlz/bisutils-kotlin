package com.flipperplz.bisutils.language.languages.param

import com.flipperplz.bisutils.language.abstraction.antlr.BisAntlrLanguageElement
import com.flipperplz.bisutils.core.io.BisOutputStream
import com.flipperplz.bisutils.generated.BisParamParser
import com.flipperplz.bisutils.generated.BisParamParser.Param_treeContext
import com.flipperplz.bisutils.linting.issue.BisLintIssue
import org.antlr.v4.runtime.ParserRuleContext
import kotlin.reflect.KClass

class BisParamRoot(
    root: Param_treeContext,
    languageFile: BisParamLanguageFile,
) : BisAntlrLanguageElement<Param_treeContext>(root, languageFile) {

    override val ruleType: KClass<out ParserRuleContext> = Param_treeContext::class
    override val elementName: String = "ParamFile Root"
    override val elementId: Short = 0

    override fun parseRule(rule: Param_treeContext) {
        TODO("Not yet implemented")
    }

    override fun lint(): List<BisLintIssue> {
        TODO("Not yet implemented")
    }

    override fun serialize(): String {
        TODO("Not yet implemented")
    }
}