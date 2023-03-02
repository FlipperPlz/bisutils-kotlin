package com.flipperplz.bisutils.core.abstraction.language

import com.flipperplz.bisutils.core.io.BisInputStream
import com.flipperplz.bisutils.core.io.BisOutputStream
import java.io.File
import java.nio.charset.Charset
import java.nio.file.Path

abstract class BisLanguageFile<
    TreeRoot: BisLanguageElement //THE CLASS THAT HOLDS THE LANGUAGE TREE
> (
    reader: BisInputStream,
    closeReader: Boolean = true,
    options: Map<String, String?> = mutableMapOf()
) {
    protected lateinit var treeRoot: TreeRoot;

    abstract val defaultCharset: Charset;

    val languageCharset: Charset = with(options["charset"]) {
        if(this == null) defaultCharset
        else Charset.forName(this);
    }
    abstract val binaryLanguage: Boolean;
    abstract val languageName: String;
    abstract val defaultOptions: Map<String, String?>;

    open val implementationType: String = "MANUAL";

    constructor(file: File, closeReader: Boolean = true) : this(BisInputStream(file), closeReader)
    constructor(path: Path, closeReader: Boolean = true) : this(path.toFile(), closeReader)

    final fun writeTo(file: File, closeWriter: Boolean = true) = write(BisOutputStream(file), closeWriter)

    final fun write(writer: BisOutputStream, closeWriter: Boolean = true) = treeRoot.write(writer, closeWriter)

}

