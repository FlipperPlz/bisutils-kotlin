package com.flipperplz.bisutils.language.abstraction

interface BisTranspileableTo<T: BisLanguageElement> {
    fun transpileTo(): T

}