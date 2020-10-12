package options

import Preferences
import api.TogglApi
import kotlinx.coroutines.*
import kotlinx.html.dom.append
import kotlinx.html.dom.create
import kotlinx.html.id
import kotlinx.html.js.*
import org.w3c.dom.*
import org.w3c.dom.events.Event
import utils.extensions.isVisible
import kotlin.browser.document
import kotlin.dom.clear

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
    private val togglTokenButton by lazy { document.getElementById("toggl-token-button") as HTMLButtonElement }
    private val saveButton by lazy { document.getElementById("save") as HTMLButtonElement }
    private val addJiraServerButton by lazy { document.getElementById("btn-add-jira") as HTMLButtonElement }
    private val jiraSection by lazy { document.getElementById("jira-section") as HTMLElement }

    fun main() {
        GlobalScope.launch(Dispatchers.Main) {
            restoreOptions()
        }

        roundType.onchange = { onRoundChange() }
        saveButton.onclick = {
            GlobalScope.launch(Dispatchers.Main) {
                saveOptions()
            }
        }

        togglTokenButton.onclick = {
            togglTokenButton.firstElementChild?.classList?.toggle("loading")
            GlobalScope.launch {
                TogglApi.getUserData().let { togglUser ->
                    togglTokenButton.firstElementChild?.classList?.toggle("loading")
                    (document.getElementsByClassName("toggl-projects")).asList().forEach { selectItem ->
                        (selectItem as HTMLSelectElement).clear()
                        selectItem.append {
                            option {
                                value = "-1"
                                label = "Select project"
                            }
                        }
                        togglUser.data.projects.forEach { project ->
                            document.create.option {
                                value = project.id.toString()
                                label = project.name
                            }.let { selectItem.add(it) }
                        }
                    }
                }
            }
        }

        addJiraServerButton.onclick = {
            addJiraServerInput()
        }
    }

    private suspend fun restoreOptions() {
        val preferences = AppPreferences.getPreferences()
        jiraUrl.value = preferences.jiraUrl
        mergeEntriesBy.value = preferences.mergeEntriesBy
        jumpToToday.checked = preferences.jumpToToday
        togglApiToken.value = preferences.togglApiToken
        roundType.value = preferences.roundType
        roundValue.value = preferences.roundValue.toString()
        roundValSection.isVisible = preferences.roundType != "no-round"
        addJiraServerInput(preferences)
    }

    private suspend fun saveOptions() {
        val options = Preferences {
            jiraUrl = this@Options.jiraUrl.value.let { if (it.endsWith("/")) it.substring(0, it.length - 1) else it }
            jiraUrls = getAddedJiraUrls().toTypedArray()
            togglProjects = getRenderedProjects().toTypedArray()
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
                    "Round duration to next x minutes. (15 will round to to the next quarter => 16 will become 30 etc.)"
            }
            "natural-round" -> {
                roundValSection.isVisible = true
                roundValLabel.textContent =
                    "Round duration to next x minutes. (15 will round to to the next quarter => 16 will become 30 etc.)"
            }
            "smart-round" -> {
                roundValSection.isVisible = true
                roundValLabel.textContent = "Target daily hours."
            }
            else -> {
            }
        }

    private fun addJiraServerInput() {
        jiraSection.append {
            input(classes = "jira-url additional-jira-url")
            select(classes = "toggl-projects") {
                option {
                    value = "-1"
                    text("Select project")
                }
            }
            div(classes = "popup") {
                onClickFunction = { e -> showProjectsHelp(e) }
                i(classes = "far fa-question-circle")
                span(classes = "popupText") {
                    id = "jiraPopup"
                    text("Select Toggl project to log into this Jira (refresh toggl token if empty)")
                }
            }
            br()
        }
    }

    private fun addJiraServerInput(preferences: Preferences) {
        preferences.jiraUrls.forEach { jira ->
            console.log(jira)
            jiraSection.append {
                input(classes = "jira-url additional-jira-url") { value = jira.second }
                select(classes = "toggl-projects") {
                    preferences.togglProjects.forEach { project ->
                        option {
                            value =  project.first.toString()
                            text(project.second)
                            selected = jira.first == project.first
                        }
                    }
                }
                div(classes = "popup") {
                    onClickFunction = { e -> showProjectsHelp(e) }
                    i(classes = "far fa-question-circle")
                    span(classes = "popupText") {
                        id = "jiraPopup"
                        text("Select Toggl project to log into this Jira (refresh toggl token if empty)")
                    }
                }
                br()
            }
        }
    }

    private fun showProjectsHelp(e: Event) {
        (document.getElementById("jiraPopup") as? HTMLElement)?.classList?.toggle("show")
    }

    private fun getRenderedProjects(): List<Pair<Int, String>> {
        (document.getElementsByClassName("toggl-projects")).let {
            if (it.length > 0) {
                return (it[0] as HTMLSelectElement).options.asList().map {
                    (it as HTMLOptionElement).let { it.value.toInt() to it.label }
                }
            }
        }
        return emptyList()
    }

    private fun getAddedJiraUrls(): List<Pair<Int, String>> {
        val items = mutableListOf<Pair<Int, String>>()
        (document.getElementsByClassName("additional-jira-url")).asList().forEach {
            if ((it as HTMLInputElement).value.isNotBlank()) {
                val url = it.value.let { if (it.endsWith("/")) it.substring(0, it.length - 1) else it }
                val selectedId = ((it.nextSibling as HTMLSelectElement).selectedOptions[0] as HTMLOptionElement).value
                items.add(selectedId.toInt() to url)
            }
        }
        return items
    }
}