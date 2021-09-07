package popup.models

import utils.js.RegExp
import kotlin.js.Date

data class WorkLog(
    var id: Long,
    var issue: String,
    var description: String,
    var comment: String,
    var started: Date,
    var dateKey: String,
    var timeSpent: String,
    var timeSpentInt: Int,
    var submit: Boolean,
    var hidden: Boolean = false,
    var projectId: Int? = null
) {
    companion object {
        /**
         * Create [WorkLog] from Toggl [description] via set [template].
         */
        fun fromTemplate(description: String, template: String): WorkLog? {
            // Use own RegExp to support named groups
            val match = RegExp(template).exec(description) ?: return null
            val groups = match.groups
            return WorkLog(
                id = -1,
                issue = groups["issue"],
                description = groups["desc"],
                comment = groups["desc"],
                started = Date(),
                dateKey = "",
                timeSpent = "",
                timeSpentInt = 0,
                submit = false,
            )
        }
    }
}