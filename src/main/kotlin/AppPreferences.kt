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
            mergeEntriesBy = "no-merge"
            jumpToToday = false
            togglApiToken = ""
            roundType = "no-round"
            roundValue = 15
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
 * @property roundType Possible values are `no-round`, `round-up`, `natural-round`, `smart-round`.
 * @property roundValue Target value for rounding.
 */
external interface Preferences {
    var jiraUrl: String
    var mergeEntriesBy: String
    var jumpToToday: Boolean
    var togglApiToken: String
    var roundType: String
    var roundValue: Int
}

@Suppress("UNCHECKED_CAST_TO_EXTERNAL_INTERFACE")
fun Preferences(prefs: Preferences.() -> Unit) = (js("{}") as Preferences).apply(prefs)