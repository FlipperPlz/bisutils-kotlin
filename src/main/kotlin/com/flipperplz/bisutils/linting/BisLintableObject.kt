package com.flipperplz.bisutils.linting

import com.flipperplz.bisutils.linting.issue.BisLintIssue

interface BisLintableObject{
    fun lint(): List<BisLintIssue>
}