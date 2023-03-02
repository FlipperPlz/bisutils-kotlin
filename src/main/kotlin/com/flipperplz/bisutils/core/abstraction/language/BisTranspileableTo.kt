package com.flipperplz.bisutils.core.abstraction.language

interface BisTranspileableTo<T: BisLanguageElement> {
    abstract fun transpileTo(): T;

}