package com.flipperplz.bisutils.linting.issue.warning

import com.flipperplz.bisutils.linting.issue.BisLintIssue
import com.flipperplz.bisutils.linting.issue.BisLintIssueType

abstract class BisLintWarning : BisLintIssue() {
    override val issueType: BisLintIssueType = BisLintIssueType.WARNING
}