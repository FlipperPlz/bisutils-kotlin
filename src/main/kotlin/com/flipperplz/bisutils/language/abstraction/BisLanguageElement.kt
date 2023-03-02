package com.flipperplz.bisutils.language.abstraction

import com.flipperplz.bisutils.core.io.BisSerializable
import com.flipperplz.bisutils.linting.BisLintableObject

abstract class BisLanguageElement(
    val languageFile: BisLanguageFile<*>
) : BisLintableObject, BisSerializable {
    abstract val elementName: String
    abstract val elementId: Short
    open val elegableGroups: List<String> = listOf( languageFile.currentLanguage() )
}