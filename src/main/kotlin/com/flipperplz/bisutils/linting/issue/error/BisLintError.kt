package com.flipperplz.bisutils.linting.issue.error

import com.flipperplz.bisutils.linting.issue.BisLintIssue
import com.flipperplz.bisutils.linting.issue.BisLintIssueType

abstract class BisLintError : BisLintIssue() {
    override val issueType : BisLintIssueType = BisLintIssueType.ERROR
}