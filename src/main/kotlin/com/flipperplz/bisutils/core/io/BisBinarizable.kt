package com.flipperplz.bisutils.core.io

interface BisBinarizable {

    fun write(writer: BisOutputStream, closeWriter: Boolean)
    fun read(reader: BisInputStream, closeReader: Boolean)
}