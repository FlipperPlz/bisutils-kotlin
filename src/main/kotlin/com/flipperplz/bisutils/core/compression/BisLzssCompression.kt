package com.flipperplz.bisutils.core.compression

import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.nio.ByteBuffer
import kotlin.math.min


class BisLzssCompression {

    companion object {
        fun writeCompressedData(data: ByteArray): ByteArray = ByteArrayOutputStream().also { output ->
            val buffer = CompressionBuffer()
            val dataLength = data.size
            var readData = 0

            while (readData < dataLength) with(CompressionPacket()) {
                readData = this.pack(data, readData, buffer)
                output.write(this.getContent())
            }
            val crc = output.toByteArray().fold(0u) { acc, byte -> acc + byte.toUInt() }.toInt()
            output.write(ByteBuffer.allocate(Int.SIZE_BYTES).putInt(crc).array())
            //TODO: Write CRC

        }.toByteArray()

        fun readCompressedData(reader: InputStream, expectedSize: Int): ByteArray {
            if (expectedSize == 0) return byteArrayOf()
            val decompressed = ByteArray(expectedSize)
            val N = 4096
            val F = 18
            val THRESHOLD = 2
            var i: Int
            var flags = 0
            var cSum = 0
            var iDst = 0
            var bytesLeft = decompressed.size
            val text_buf = CharArray(N + F - 1)
            i = 0
            while (i < N - F) {
                text_buf[i] = ' '
                i++
            }
            var r = N - F
            while (bytesLeft > 0) {
                var c: Int
                if (1.let { flags = flags shr it; flags } and 256 == 0) {
                    c = reader.read()
                    flags = c or 0xff00
                }
                if (flags and 1 != 0) {
                    c = reader.read()
                    cSum += c
                    decompressed[iDst++] = c.toByte()
                    bytesLeft--
                    text_buf[r] = c.toChar()
                    r++
                    r = r and N - 1
                } else {
                    i = reader.read()
                    var j = reader.read()
                    i = i or (j and 0xf0 shl 4)
                    j = j and 0x0f
                    j += THRESHOLD
                    var ii = r - i
                    val jj = j + ii
                    if (j + 1 > bytesLeft) throw IOException("LZSS Overflow!")
                    while (ii <= jj) {
                        c = text_buf[ii and N - 1].code.toByte().toInt()
                        cSum += c
                        decompressed[iDst++] = c.toByte()
                        bytesLeft--
                        text_buf[r] = c.toChar()
                        r++
                        r = r and N - 1
                        ii++
                    }
                }
            }
            val csrBytes = ByteArray(4)
            reader.read(csrBytes, 0, 4)
            val csr = ByteBuffer.wrap(csrBytes).int
            //TODO: Fix checksum calculation for the JVM's signed bytes
            //if (csr != cSum) throw IOException("Checksum mismatch")
            return decompressed
        }
    }

    internal class CompressionPacket {
        private val dataBlockCount = 8
        private val minimumPackBytes = 3
        private val maximumDataBlockSize = minimumPackBytes + 0b1111
        private val maximumOffsetForWhitespaces = 0b0000111111111111 - maximumDataBlockSize

        private var flagbits = 0
        val content = mutableListOf<Byte>()
        private lateinit var next: MutableList<Byte>
        private var compressionBuffer = CompressionBuffer()

        fun pack(data: ByteArray, currPosition: Int, buffer: CompressionBuffer): Int {
            compressionBuffer = buffer

            var curr = currPosition;

            for (i in 0 until dataBlockCount ) {
                if (curr >= data.size) break
                val blockSize = min(maximumDataBlockSize, data.size - curr)
                if (blockSize < minimumPackBytes) {
                    curr += addUncompressed(i, data, curr)
                    continue
                }
                curr += addCompressed(i, data, curr, blockSize)
            }

            return curr
        }

        private fun addCompressed(blockIndex: Int, data: ByteArray, currPos: Int, blockSize: Int): Int {
            next = mutableListOf();
            for (i in 0 until blockSize) next.add(data[currPos + i])

            val nextAsArray = next.toByteArray()
            val intersection = compressionBuffer.intersect(nextAsArray, blockSize)
            val whitespace = if (currPos < maximumOffsetForWhitespaces) compressionBuffer.checkWhitespace(nextAsArray, blockSize) else 0
            val sequence = compressionBuffer.checkSequence(nextAsArray, blockSize)

            if (intersection.length < minimumPackBytes && whitespace < minimumPackBytes && sequence.sourceBytes < minimumPackBytes)
                return addUncompressed(blockIndex, data, currPos)

            var processed = 0
            var pointer: Short = 0
            if (intersection.length >= whitespace && intersection.length >= sequence.sourceBytes) {
                pointer = createPointer(compressionBuffer.content.size - intersection.position, intersection.length)
                processed = intersection.length
            } else if (whitespace >= intersection.length && whitespace >= sequence.sourceBytes) {
                pointer = createPointer(currPos + whitespace, whitespace)
                processed = whitespace
            } else {
                pointer = createPointer(sequence.sequenceBytes, sequence.sourceBytes)
                processed = sequence.sourceBytes
            }
            compressionBuffer.addBytes(data, currPos, processed)

            var crc = pointer.toInt()
            content.add((crc and 0x00FF).toByte())
            content.add(((crc and 0xFF00) shr (8)).toByte())

            return processed
        }

        private fun createPointer(offset: Int, length: Int): Short {
            val lengthEntry = (length - minimumPackBytes shl 8)
            val offsetEntry = ((offset and 0x0F00 shl 4) + (offset and 0x00FF))
            return (offsetEntry + lengthEntry).toShort()

        }

        fun getContent(): ByteArray {
            val output = ByteArray(1 + content.size)
            output[0] = flagbits.toByte()

            for (i in 1 until output.size) output[i] = content[i - 1]

            return output
        }


        private fun addUncompressed(blockIndex: Int, data: ByteArray, currPos: Int): Int {
            compressionBuffer.addByte(data[currPos])
            content.add(data[currPos])
            flagbits = flagbits or (1 shl blockIndex)
            return 1
        }


    }
    internal class CompressionBuffer(size: Long = 0) {
        data class CompressionIntersection(var position: Int, var length: Int)
        data class CompressionSequence(var sourceBytes: Int, var sequenceBytes: Int)

        val size: Long
        val content: MutableList<Byte>

        init {
            this.size = if(size == 0L) 0b0000111111111111 else size
            content = mutableListOf()
        }

        fun addBytes(data: ByteArray, currPosition: Int, length: Int) {
            for (i in 0..length) {
                if(size < content.size + 1) content.removeAt(0)

                content.add(data[currPosition + i])
            }
        }

        fun addByte(data: Byte) {
            if(size < content.size + 1) content.removeAt(0)
            content.add(data)
        }

        fun intersect(buffer: ByteArray, length: Int): CompressionIntersection {
            var intersection = CompressionIntersection(-1, 0)
            if(length == 0 || content.size == 0) return intersection

            var offset = 0
            while (true) {
                val next = intersectAtOffset(buffer, length, offset)

                if(next.position >= 0 && intersection.length < next.length) intersection = next
                if(next.position < 0 || next.position > content.size - 1) break

                offset = next.position + 1
            }

            return intersection
        }

        fun intersectAtOffset(buffer: ByteArray, bLength: Int, offset: Int): CompressionIntersection {
            val position = content.indexOf(buffer[0], offset)
            var length = 0

            if (position >= 0 && position < content.size) {
                length++
                for (bufIndex in 1 until bLength) {
                    val dataIndex = position + bufIndex
                    if (dataIndex >= content.size || content[dataIndex] != buffer[bufIndex]) break
                    length++
                }
            }

            return CompressionIntersection(position, length)
        }

        fun checkWhitespace(buffer: ByteArray, length: Int): Int {
            var count = 0
            for (i in 0 until length) {
                if(buffer[i] != 0x20.toByte()) break
                count++
            }

            return count
        }

        fun checkSequence(buffer: ByteArray, length: Int): CompressionSequence {
            var result = CompressionSequence(0, 0)
            val maxSourceBytes = min(content.size, length)
            for (i in 1 until maxSourceBytes) {
                val sequence = checkSequenceImpl(buffer, length, i)
                if (sequence.sourceBytes > result.sourceBytes) result = sequence
            }

            return result
        }

        private fun checkSequenceImpl(buffer: ByteArray, length: Int, sequenceBytes: Int): CompressionSequence {
            var sourceBytes = 0

            while (sourceBytes < length) {
                for (i in (content.size - sequenceBytes) until content.size) {
                    if (sourceBytes >= length) break
                    if (buffer[sourceBytes] != content[i]) {
                        return CompressionSequence(sourceBytes, sequenceBytes)
                    }
                    sourceBytes++
                }
            }
            return CompressionSequence(sequenceBytes, sourceBytes)
        }

        private fun MutableList<Byte>.indexOf(byte: Byte, offset: Int): Int = this.toMutableList().drop(offset).indexOf(byte) + offset
    }
}