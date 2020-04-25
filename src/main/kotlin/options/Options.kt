package options

import Preferences
import kotlinx.coroutines.*
import org.w3c.dom.*
import utils.extensions.isVisible
import kotlin.browser.document

@Suppress("UnsafeCastFromDynamic")
class Options {

    private val jiraUrl by lazy { document.getElementById("jira-url") as HTMLInputElement }
    private val mergeEntriesBy by lazy { document.getElementById("merge-entries-by") as HTMLSelectElement }
    private val togglApiToken by lazy { document.getElementById("toggl-api-token") as HTMLInputElement }
    private val jumpToToday by lazy { document.getElementById("jump-to-today") as HTMLInputElement }
    private val roundType by lazy { document.getElementById("round-type") as HTMLSelectElement }
    private val roundValue by lazy { document.getElementById("round-value") as HTMLInputElement }
    private val roundValSection by lazy { document.getElementById("round-val-section") as HTMLElement }
    private val roundValLabel by lazy { document.getElementById("round-value-label") as HTMLElement }
    private val saveButton by lazy { document.getElementById("save") as HTMLButtonElement }

    fun main() {
        restoreOptions(getDefaults())

        roundType.onchange = { onRoundChange() }
        saveButton.onclick = {
            GlobalScope.launch(Dispatchers.Main) {
                saveOptions()
            }
        }
    }

    private fun restoreOptions(defaults: dynamic) {
        chrome.storage.sync.get(defaults) { items ->
            jiraUrl.value = items["jiraUrl"]
            mergeEntriesBy.value = items["mergeEntriesBy"]
            jumpToToday.checked = items["jumpToToday"]
            togglApiToken.value = items["togglApiToken"]
            roundType.value = items["roundType"]
            roundValue.value = items["roundValue"]
            roundValSection.isVisible = items["roundType"] != "no-round"
        }
    }

    private suspend fun saveOptions() {
        val options = Preferences {
            jiraUrl = this@Options.jiraUrl.value.let { if (it.endsWith("/")) it.substring(0, it.length - 1) else it }
            mergeEntriesBy = this@Options.mergeEntriesBy.value
            jumpToToday = this@Options.jumpToToday.checked
            togglApiToken = this@Options.togglApiToken.value
            roundType = this@Options.roundType.value
            roundValue = this@Options.roundValue.value.toInt()
        }

        AppPreferences.setPreferences(options).join()

        document.getElementById("status")?.apply {
            textContent = "Options saved."
            delay(750)
            textContent = ""
        }
    }

    private fun onRoundChange() =
        when (roundType.value) {
            "no-round" -> {
                roundValSection.isVisible = false
            }
            "round-up" -> {
                roundValSection.isVisible = true
                roundValLabel.textContent =
                    "Round duration to next x minutes. (15 will round to to the next quater => 16 will become 30 etc.)"
            }
            "natural-round" -> {
                roundValSection.isVisible = true
                roundValLabel.textContent =
                    "Round duration to next x minutes. (15 will round to to the next quater => 16 will become 30 etc.)"
            }
            "smart-round" -> {
                roundValSection.isVisible = true
                roundValLabel.textContent = "Target daily hours."
            }
            else -> {
            }
        }

    companion object {
        fun getDefaults(): dynamic {
            val defaults = js("{}")
            defaults["jiraUrl"] = "https://jira.atlassian.net"
            defaults["mergeEntriesBy"] = "no-merge"
            defaults["jumpToToday"] = false
            defaults["togglApiToken"] = ""
            defaults["roundType"] = "no-round"
            defaults["roundValue"] = "15"
            return defaults
        }
    }
}