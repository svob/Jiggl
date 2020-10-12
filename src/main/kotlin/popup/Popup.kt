package popup

import Preferences
import api.JiraApi
import api.TogglApi
import api.models.LogWorkInput
import io.ktor.http.HttpStatusCode
import io.ktor.http.isSuccess
import kotlinx.coroutines.*
import kotlinx.html.*
import kotlinx.html.dom.append
import kotlinx.html.dom.create
import kotlinx.html.js.tr
import org.w3c.dom.*
import popup.models.WorkLog
import utils.extensions.*
import kotlin.browser.document
import kotlin.browser.localStorage
import kotlin.dom.addClass
import kotlin.dom.removeClass
import kotlin.js.Date
import kotlin.math.*

class Popup {

    private val startPicker by lazy { document.getElementById("start-picker") as HTMLInputElement }
    private val endPicker by lazy { document.getElementById("end-picker") as HTMLInputElement }
    private val submit by lazy { document.getElementById("submit") as HTMLButtonElement }
    private val checkAll by lazy { document.getElementById("check-all") as HTMLInputElement }
    private val searchBox by lazy { document.querySelector("#search-box input") as HTMLInputElement }
    private val searchBoxIcon by lazy { document.querySelector("#search-box i") as HTMLElement }

    private lateinit var settings: Preferences

    private val myEmailAddresses = hashMapOf<String, String>() // jira url to mail
    private val logs = mutableListOf<WorkLog>()
    private var issuesCheckboxes: List<Element>? = null

    fun main() {
        GlobalScope.launch(Dispatchers.Default) {
            settings = withContext(Dispatchers.Main) { AppPreferences.getPreferences() }
            val lastStart = localStorage.getItem("jiggl.last-date")
            val startDate = if (settings.jumpToToday || lastStart.isNullOrEmpty()) Date() else Date(lastStart)
            startPicker.valueAsDate = startDate

            val lastEnd = localStorage.getItem("jiggl.last-end-date")
            val endDate = if (settings.jumpToToday || lastEnd.isNullOrEmpty()) {
                Date(Date.now() + (3600 * 24 * 1000))
            } else {
                Date(lastEnd)
            }
            endPicker.valueAsDate = endDate

            startPicker.onchange = {
                fetchEntries()
            }
            endPicker.onchange = startPicker.onchange
            submit.onclick = {
                submitEntries()
            }

            checkAll.onchange = {
                checkAll(checkAll.checked)
            }

            searchBox.onchange = {
                filterEntries(searchBox.value)
            }
            searchBoxIcon.onclick = searchBox.onchange

            setUserData()
            fetchEntries()
        }
    }

    private suspend fun setUserData() {
        val statusDiv = document.getElementById("jira-status") as HTMLDivElement
        JiraApi.getUserData(settings.jiraUrl).let {
            myEmailAddresses.put(settings.jiraUrl, it.emailAddress)
            statusDiv.append {
                div { text("${it.displayName} (${it.emailAddress})") }
            }
        }
        settings.jiraUrls.forEach { jiraUrl ->
            JiraApi.getUserData(jiraUrl.second).let { jiraUser ->
                myEmailAddresses.put(jiraUrl.second, jiraUser.emailAddress)
                statusDiv.append {
                    div { text("${jiraUser.displayName} (${jiraUser.emailAddress})") }
                }
            }
        }
    }

    private fun fetchEntries() {
        val startDate = startPicker.valueAsDate as Date
        var endDate = endPicker.valueAsDate as Date
        localStorage.setItem("jiggl.last-date", startDate.toISOString())
        localStorage.setItem("jiggl.last-end-date", endDate.toISOString())
        document.getElementById("error")?.apply {
            textContent = ""
            removeClass("error")
        }

        // to get also the end date from Toggl
        endDate = endDate.addDays(1)

        logs.clear()
        GlobalScope.launch {
            // Toggl returns entries in UTC timezone so we need to filter them to match user`s timezone.
            val entries = TogglApi.getTimeEntries(startDate, endDate)
                .filter { it.start.isBefore(endDate) && !it.start.isBefore(startDate) }.reversed()
            console.log(entries)

            entries.forEach { entry ->
                val issue = entry.description.split(' ')[0]

                var log = logs.find {
                    when (settings.mergeEntriesBy) {
                        "issue-and-date" -> {
                            it.issue == issue && it.dateKey == entry.start.toDateString()
                        }
                        "issue-and-date-and-desc" -> {
                            it.issue == issue && it.dateKey == entry.start.toDateString() && it.description == entry.description
                        }
                        else -> {
                            it.issue == issue
                        }
                    }
                }

                if (log != null && settings.mergeEntriesBy != "no-merge") {
                    log.timeSpentInt += entry.duration
                    log.timeSpent =
                        if (log.timeSpentInt > 0) log.timeSpentInt.toString().toHH_MM() else "still running..."
                } else {
                    log = WorkLog(
                        id = entry.id,
                        issue = issue.ifEmpty { "no-description" },
                        description = entry.description,
                        submit = entry.duration > 0,
                        timeSpentInt = if (entry.duration > 0) entry.duration else 0,
                        timeSpent = if (entry.duration > 0) entry.duration.toString().toHH_MM() else "still running...",
                        comment = entry.description.substring(issue.length),
                        started = entry.start,
                        dateKey = entry.start.toDateString(),
                        projectId = entry.pid
                    )
                    logs.add(log)
                }
            }

            if (settings.roundType != "no-round") {
                val roundDelegate = { timeSpentInt: Int ->
                    if (settings.roundType == "round-up") {
                        roundUp(timeSpentInt, settings.roundValue)
                    } else {
                        naturalRound(timeSpentInt, settings.roundValue)
                    }
                }

                logs.forEach {
                    it.timeSpentInt = roundDelegate(it.timeSpentInt)
                    it.timeSpent = it.timeSpentInt.toString().toHH_MM()
                }
            }

            renderEntries()
        }
    }

    private fun submitEntries() {
        logs.forEach {
            if (!it.submit || it.hidden) return@forEach

            val checkboxElement = document.getElementById(it.id.toString()) as? HTMLInputElement
            val commentElement = document.getElementById("comment-${it.id}") as? HTMLInputElement
            val resultElement = document.getElementById("result-${it.id}")?.apply {
                textContent = "Pending..."
                addClass("info")
            }

            val input = LogWorkInput(
                comment = commentElement?.value.let { if (it.isNullOrBlank()) settings.defaultComment else it },
                timeSpentSeconds = it.timeSpentInt,
                started = it.started
            )

            GlobalScope.launch {
                val jiraUrl = getJiraForProject(it.projectId)
                JiraApi.logWork(jiraUrl, it.issue, input).let { status ->
                    if (status.isSuccess()) {
                        it.submit = false
                        resultElement?.apply {
                            textContent = "OK"
                            addClass("success")
                            removeClass("info")
                        }
                        commentElement?.disabled = true
                        checkboxElement?.apply {
                            checked = false
                            disabled = true
                        }
                    } else {
                        val e = when (status) {
                            HttpStatusCode.NotFound -> "Issue ${it.issue} not found"
                            else -> "error"
                        }
                        document.querySelector("p#error")?.apply {
                            textContent = e
                            addClass("error")
                        }
                    }
                }
            }
        }
    }

    /**
     * Round duration up to next `minutes`.
     * No rounding will be applied if minutes is zero.
     *
     * Example: round to next quarter:
     *  roundUp(22, 15) = 30 // rounded to the next quarter
     *  roundUp(35, 60) = 60 // round to full hour
     *  roundUp(11, 0) = 11 // ignored rounding
     *
     * @param initialDuration Initial duration in seconds.
     *
     * @returns Rounded duration in seconds.
     */
    private fun roundUp(initialDuration: Int, roundingMinutes: Int): Int {
        val minutesDuration = initialDuration / 60
        return if (minutesDuration == 0 || roundingMinutes == 0) {
            initialDuration
        } else {
            val roundedDuration = ceil(minutesDuration / roundingMinutes.toFloat()) * roundingMinutes
            (roundedDuration * 60).toInt()
        }
    }

    /**
     * Naturally round duration by rounding_minutes.
     * No rounding will be applied if minutes is zero.
     *
     * @param initialDuration Initial duration in seconds.
     */
    private fun naturalRound(initialDuration: Int, roundingMinutes: Int): Int {
        val minutesDuration = initialDuration / 60
        return if (minutesDuration == 0 || roundingMinutes == 0) {
            initialDuration
        } else {
            val roundedDuration = (minutesDuration / roundingMinutes.toFloat()).roundToInt() * roundingMinutes
            (roundedDuration * 60)
        }
    }

    /**
     * TODO
     */
    private fun smartRound() {

    }

    private suspend fun renderEntries() {
        submit.disabled = true
        val table = document.create.tbody()

        logs.forEach {
            if (!it.hidden) {
                table.append.tr {
                    td {
                        if (it.timeSpentInt > 0) {
                            input {
                                type = InputType.checkBox
                                checked = true
                                id = it.id.toString()
                                classes = setOf("issue-checkbox")
                            }
                        }
                    }
                    td {
                        a {
                            href = "${settings.jiraUrl}/browse/${it.issue}"
                            target = "_blank"
                            text(it.issue)
                        }
                    }
                    td {
                        text(it.description.substring(it.issue.length).ellipsize(35))
                    }
                    td {
                        text(it.started.toDDMM())
                    }
                    if (it.timeSpentInt > 0) {
                        td {
                            text(it.timeSpent)
                        }
                        td {
                            input {
                                type = InputType.text
                                value = it.comment
                                id = "comment-${it.id}"
                            }
                        }
                        td {
                            id = "result-${it.id}"
                        }
                    } else {
                        td {
                            colSpan = "3"
                            style = "text-align:center;"
                            text("still running...")
                        }
                    }
                    td {
                        id = "loader-${it.id}"
                    }
                }
            }
        }

        val totalTime = logs.fold(0, { acc, log -> acc + log.timeSpentInt })
        table.append.tr {
            td(); td(); td()
            td { b { text("TOTAL") } }
            td { text(totalTime.toString().toHHMM()) }
        }

        document.getElementById("toggl-entries")?.innerHTML = table.innerHTML

        issuesCheckboxes = document.getElementsByClassName("issue-checkbox").asList().apply {
            forEach {
                (it as HTMLInputElement).onchange = { _ ->
                    onIssueCheckChanged(it)
                }
            }
        }

        val jobs: MutableList<Job> = mutableListOf()
        logs.forEach { log ->
            val loader = (document.getElementById("loader-${log.id}") as HTMLElement)
            loader.apply {
                classList.add("loading")
            }
            if (!log.hidden) {
                val job = GlobalScope.launch {
                    val jiraUrl = getJiraForProject(log.projectId)
                    JiraApi.getWorklog(jiraUrl, log.issue)?.worklogs?.forEach { worklog ->
                        if (myEmailAddresses[jiraUrl] == worklog.author.emailAddress) {
                            val diff = abs(floor(worklog.timeSpentSeconds / 60f) - floor(log.timeSpentInt / 60f))
                            if (worklog.started.toDDMM() == log.started.toDDMM() && diff == 0f) {
                                (document.getElementById("result-${log.id}") as HTMLElement).apply {
                                    textContent = "OK"
                                    classList.add("success")
                                    classList.remove("info")
                                }
                                (document.getElementById(log.id.toString()) as HTMLInputElement).apply {
                                    checked = false
                                    disabled = true
                                }
                                (document.getElementById("comment-${log.id}") as HTMLInputElement).apply {
                                    disabled = true
                                }
                                log.submit = false
                            }
                        }
                    }
                }
                job.invokeOnCompletion {
                    loader.classList.remove("loading")
                }
                jobs.add(job)
            }
        }
        jobs.joinAll()
        submit.disabled = false
    }

    private fun onIssueCheckChanged(element: HTMLInputElement) {
        logs.find { l -> element.id == l.id.toString() }
            ?.apply {
                submit = element.checked
            }
    }

    private fun checkAll(check: Boolean) {
        issuesCheckboxes?.forEach {
            if (!(it as HTMLInputElement).disabled) {
                it.checked = check
                onIssueCheckChanged(it)
            }
        }
    }

    private fun filterEntries(input: String) {
        val regex = input.toRegex(RegexOption.IGNORE_CASE)
        logs.forEach {
            it.hidden = !regex.containsMatchIn(it.issue)
        }

        GlobalScope.launch {
            renderEntries()
        }
    }

    private fun getJiraForProject(projectId: Int?): String =
        settings.jiraUrls.find { projectId == it.first }?.second
            ?: settings.jiraUrl
}