package com.flipperplz.bisutils.core.io

import org.apache.commons.io.output.CountingOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder

class BisOutputStream : CountingOutputStream {
    private val writingTo: File?
    var closed: Boolean = false

    constructor(outputStream: OutputStream) : super(outputStream) { writingTo = null}
    constructor(outFile: File) : super(FileOutputStream(outFile)) { writingTo = outFile }

    fun writeUByte(data: UByte = 0u) = write(data.toInt())
    @OptIn(ExperimentalUnsignedTypes::class)
    fun writeUBytes(data: UByteArray, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = if(endianness == ByteOrder.LITTLE_ENDIAN)
        data.reversed().forEach { writeUByte(it) } else data.forEach { writeUByte(it) }
    fun writeJavaByte(data: Byte = 0) = write(data.toInt())
    fun writeByte(data: Int = 0) = write(data)
    fun writeByte(data: Byte = 0) = write(data.toInt())
    fun writeBytes(data: IntArray, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = if(endianness == ByteOrder.LITTLE_ENDIAN)
        data.reversed().forEach { writeByte(it) } else data.forEach { writeByte(it)  }
    fun writeBytes(data: ByteArray, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = if(endianness == ByteOrder.LITTLE_ENDIAN)
        data.reversed().forEach { writeByte(it) } else data.forEach { writeByte(it) }
    fun writeCompactInteger(data: Int) {
        var i = data
        while (i > 0x7F) {
            writeByte((i and 0x7F) or 0x80)
            i = i ushr 7
        }; writeByte(i)
    }

    fun writeAsciiZ(data: String) { writeBytes(data.toByteArray(Charsets.UTF_8)); writeByte(0); }

    fun writeInt32(data: Int, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = writeBytes(ByteBuffer.allocate(4).putInt(data).array(), endianness)
    fun writeUInt32(data: UInt) = (0..31).forEach { writeByte(((data shr it) and 1u).toInt()) }

    fun writeLong64(data: Long, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = writeBytes(ByteBuffer.allocate(8).putLong(data).array(), endianness)
    fun writeULong64(data: ULong) = (0..7).forEach { writeByte((data shr (it * 8)).toInt()) }

    fun writeShort16(data: Short, endianness: ByteOrder = ByteOrder.BIG_ENDIAN) = writeBytes(ByteBuffer.allocate(2).putShort(data).array(), endianness)
    fun writeUShort16(data: UShort) = (0..1).forEach { writeByte((data.toInt() ushr (it * 8))) }

    override fun close() {
        if(closed) return
        closed = true
        super.close()
    }

    companion object {
        fun closedOrNull(stream: BisOutputStream?): Boolean = stream?.closed ?: true
    }
}