package com.flipperplz.bisutils.linting.issue

abstract class BisLintIssue {
    abstract val issueType: BisLintIssueType
    abstract val issueId: Long
    abstract val issueDescription: String
    abstract val possibleFixDescription: String

    override fun toString(): String = "(${issueType.issueChar}${issueId.toString(16)}) $issueDescription \r\n Possible Fix: $possibleFixDescription"
}