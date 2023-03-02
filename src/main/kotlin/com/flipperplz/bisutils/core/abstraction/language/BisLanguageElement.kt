package com.flipperplz.bisutils.core.abstraction.language

import com.flipperplz.bisutils.core.io.BisOutputStream

abstract class BisLanguageElement(
    val languageFile: BisLanguageFile<*>
) {
    abstract val elementName: String;
    abstract val elementId: Short;

    abstract fun write(writer: BisOutputStream, closedWriter: Boolean = true);
}