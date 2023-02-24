package com.flipperplz.bisutils.core.abstraction

interface BisSerializable {
    fun serialize(builder: StringBuilder, options: Map<String, String?>? = null): Boolean;
    fun deserialize(string: String, options: Map<String, String?>? = null): Boolean;
}