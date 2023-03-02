package com.flipperplz.bisutils.linting.issue

enum class BisLintIssueType(
    val issueChar: Char
) {
    WARNING('w'),
    ERROR('e');
}