package com.flipperplz.bisutils.language.preprocessor.directives

data class BisIncludeDirective(
    val includePath: String,
    val configNotation: Boolean
) {
    constructor(
        parsedPath: String
    ) : this(
        parsedPath.substring(1, parsedPath.length - 1),
        parsedPath.startsWith('<')
    )

}