package com.flipperplz.bisutils.core.io

interface BisSerializable {
    fun serialize(): String
    fun deserialize(data: String)
}