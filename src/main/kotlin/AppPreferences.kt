import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

/**
 * Object for accessing app-wide preferences.
 */
object AppPreferences {

    suspend fun getPreferences(): Preferences =
        suspendCoroutine {
            chrome.storage.sync.get(getDefaults()) { items ->
                it.resume(items)
            }
        }

    fun setPreferences(prefs: Preferences): Job =
        GlobalScope.launch(Dispatchers.Default) {
            chrome.storage.sync.set(prefs)
        }

    private fun getDefaults(): Preferences =
        Preferences {
            jiraUrl = "https://jira.atlassian.net"
            jiraUrls = arrayOf()
            togglProjects = arrayOf(-1 to "Select project")
            mergeEntriesBy = "no-merge"
            jumpToToday = false
            togglApiToken = ""
            togglTemplate = "(?<issue>.*?-\\d+) ?(?<desc>.*)"
            roundType = "no-round"
            roundValue = 15
            defaultComment = "Logged by Jiggl Chrome Extension"
        }
}

/**
 * Model class for app preferences.
 *
 * @property jiraUrl Base JIRA url.
 * @property mergeEntriesBy Selected merging options of toggl entries.
 *                          Possible values are `no-merge`, `issue-only`, `issue-and-date`, `issue-and-date-and-desc`.
 * @property jumpToToday Flag whether date picker should show today date by default.
 * @property togglApiToken User`s Toggl API token.
 * @property togglTemplate Template for parsing Toggl entries.
 * @property roundType Possible values are `no-round`, `round-up`, `natural-round`, `smart-round`.
 * @property roundValue Target value for rounding.
 * @property defaultComment Default log comment, used when none is specified in toggl.
 */
external interface Preferences {
    var jiraUrl: String
    var jiraUrls: Array<Pair<Int, String>> // Toggl project id -> Jira url
    var togglProjects: Array<Pair<Int, String>> // Project id -> project name
    var mergeEntriesBy: String
    var jumpToToday: Boolean
    var togglApiToken: String
    var togglTemplate: String
    var roundType: String
    var roundValue: Int
    var defaultComment: String
}

@Suppress("UNCHECKED_CAST_TO_EXTERNAL_INTERFACE")
fun Preferences(prefs: Preferences.() -> Unit) = (js("{}") as Preferences).apply(prefs)