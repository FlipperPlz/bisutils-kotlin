package com.flipperplz.bisutils.language.abstraction.element

import com.flipperplz.bisutils.language.abstraction.BisLanguageElement
import com.flipperplz.bisutils.language.abstraction.BisLanguageFile
import com.flipperplz.bisutils.linting.issue.BisLintIssue


class BisElementGroup<
    ElementType: BisLanguageElement
>(
    private val groupName: String?,
    private val elementSeparator: String = "\r\n",
    private val deserializeFunction: (elementGroup: String) -> Unit,
    languageFile: BisLanguageFile<*>
) : MutableList<ElementType> by mutableListOf(), BisLanguageElement(languageFile) {

    override val elementId: Short get() = -1;
    override val elementName: String = "ElementGroup"

    override fun lint(): List<BisLintIssue> = flatMap { it.lint() }

    override fun serialize(): String = joinToString(elementSeparator) { it.serialize() }

    override fun deserialize(data: String) = deserializeFunction.invoke(data)
}