package com.flipperplz.bisutils.language.abstraction

import com.flipperplz.bisutils.core.io.BisSerializable
import java.nio.charset.Charset

abstract class BisLanguageFile<
    TreeRoot: BisLanguageElement //THE CLASS THAT HOLDS THE LANGUAGE TREE
> (
    private val options: Map<String, String?> = mutableMapOf()
) : BisSerializable {
    protected lateinit var treeRoot: TreeRoot

    open val implementationType: String = "MANUAL"
    abstract val defaultCharset: Charset
    abstract val binaryLanguage: Boolean
    abstract val defaultLanguage: String
    open val defaultOptions: Map<String, String?> = mutableMapOf(Pair("language", "default"), Pair("charset", "default"))

    fun currentCharset(): Charset = getOrDefault("charset", ::defaultCharset) {
        Charset.forName(it)
    }

    fun currentLanguage(): String = getOrDefault("language", ::defaultLanguage) {
        it
    }

    protected fun <T> getOrDefault(key: String, getHardCodedDefault: () -> T, stringToType: (String) -> T): T = with(options[key] ?: defaultOptions[key] ?: "default") {
        if(this == "default") getHardCodedDefault.invoke()
        else stringToType.invoke(this)
    }
}

