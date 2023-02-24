package com.flipperplz.bisutils.core.io

import org.apache.commons.io.input.CountingInputStream
import java.io.File
import java.io.FileInputStream
import java.io.InputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.charset.Charset

@OptIn(ExperimentalUnsignedTypes::class)
open class BisInputStream : CountingInputStream {
    private val readingFrom: File?
    public var closed: Boolean = false

    constructor(inputStream: InputStream?) : super(inputStream) { readingFrom = null }
    constructor(inputFile: File?) : super(FileInputStream(inputFile)) { readingFrom = inputFile }

    fun readByte(): Int = read()
    fun readJavaByte(): Byte = read().toByte()
    fun readJavaBytes(count: Int, endianness: ByteOrder = ByteOrder.BIG_ENDIAN): ByteArray {
        val buffer = (0 until count).map { readJavaByte() }.toByteArray()
        return if(endianness == ByteOrder.LITTLE_ENDIAN) buffer.reversedArray() else buffer
    }
    fun readUByte(): UByte = read().toUByte()


    fun readUBytes(count: Int, endianness: ByteOrder = ByteOrder.BIG_ENDIAN): UByteArray {
        val buffer =(0 until count).map { readUByte() }.toUByteArray()
        return if(endianness == ByteOrder.LITTLE_ENDIAN) buffer.reversedArray() else buffer
    }

    fun readBytes(count: Int, endianness: ByteOrder = ByteOrder.BIG_ENDIAN): IntArray {
        val buffer = (0 until count).map { readByte() }.toIntArray()
        return if(endianness == ByteOrder.LITTLE_ENDIAN) buffer.reversedArray() else buffer
    }

    fun readBytesAsPrimitive(count: Int, endianness: ByteOrder = ByteOrder.BIG_ENDIAN): ByteArray {
        val buffer = (0 until count).map { readByte().toByte() }.toByteArray()
        return if(endianness == ByteOrder.LITTLE_ENDIAN) buffer.reversedArray() else buffer
    }

    fun readCompactInteger(): Int = generateSequence { readByte() }
        .takeWhile { it and 0x80 != 0 }
        .fold(0) { acc, v -> acc or (v and 0x7F shl (7 * acc)) }
    fun readAsciiZ(charset: Charset = Charsets.UTF_8): String = generateSequence { readByte() }
        .takeWhile { Char(it) != '\u0000' }
        .toList()
        .map { it.toByte()}
        .toByteArray()
        .let { String(it, Charsets.UTF_8) }
    fun readInt32(endianness: ByteOrder = ByteOrder.BIG_ENDIAN): Int = ByteBuffer.wrap(readBytesAsPrimitive(4, endianness)).int
    fun readUInt32(endianness: ByteOrder = ByteOrder.BIG_ENDIAN): UInt = with(readBytesAsPrimitive(4, endianness)) {
        return (this[0].toUInt() and 0xffu) or
                (this[1].toUInt() and 0xffu shl 8) or
                (this[2].toUInt() and 0xffu shl 16) or
                (this[3].toUInt() and 0xffu shl 24)
    }
    fun readULong64(endianness: ByteOrder = ByteOrder.BIG_ENDIAN): ULong = with(readBytesAsPrimitive(8, endianness)) {
        return (this[0].toULong() and 0xffu) or
                (this[1].toULong() and 0xffu shl 8) or
                (this[2].toULong() and 0xffu shl 16) or
                (this[3].toULong() and 0xffu shl 24) or
                (this[4].toULong() and 0xffu shl 32) or
                (this[5].toULong() and 0xffu shl 40) or
                (this[6].toULong() and 0xffu shl 48) or
                (this[7].toULong() and 0xffu shl 56)
    }
    fun readLong64(endianness: ByteOrder = ByteOrder.BIG_ENDIAN): Long = with(readBytesAsPrimitive(8, endianness)) {
        return (this[0].toLong() and 0xff) or
                (this[1].toLong() and 0xff shl 8) or
                (this[2].toLong() and 0xff shl 16) or
                (this[3].toLong() and 0xff shl 24) or
                (this[4].toLong() and 0xff shl 32) or
                (this[5].toLong() and 0xff shl 40) or
                (this[6].toLong() and 0xff shl 48) or
                (this[7].toLong() and 0xff shl 56)
    }
    fun readUShort16(endianness: ByteOrder = ByteOrder.BIG_ENDIAN): UShort = with(readBytes(2, endianness)) {
        return (this[0] and 0xff shl 8 or this[1] and 0xff).toUShort()
    }
    fun readShort16(endianness: ByteOrder): Short = with(readBytes(2, endianness)) {
        return (this[0] shl 8 or this[1]).toShort()
    }

    override fun close() {
        if(closed) return
        closed = true
        super.close()
    }


    companion object {
        fun closedOrNull(stream: BisInputStream?): Boolean = stream?.closed ?: true
    }
}