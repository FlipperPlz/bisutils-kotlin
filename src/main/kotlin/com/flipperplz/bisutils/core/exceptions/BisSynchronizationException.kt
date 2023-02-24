package com.flipperplz.bisutils.core.exceptions


class BisSynchronizationException(synchronizationContext: String, message: String) : Exception("[$synchronizationContext] $message")