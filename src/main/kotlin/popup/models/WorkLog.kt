package popup.models

import kotlin.js.Date

data class WorkLog(
    var id: Int,
    var issue: String,
    var description: String,
    var comment: String,
    var started: Date,
    var dateKey: String,
    var timeSpent: String,
    var timeSpentInt: Int,
    var submit: Boolean
)