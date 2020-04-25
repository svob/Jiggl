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
import org.w3c.dom.HTMLButtonElement
import org.w3c.dom.HTMLElement
import org.w3c.dom.HTMLInputElement
import org.w3c.dom.asList
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

    private lateinit var settings: Preferences
    private lateinit var myEmailAddress: String

    private val logs = mutableListOf<WorkLog>()

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

            setUserData()
            fetchEntries()
        }
    }

    private suspend fun setUserData() {
        GlobalScope.launch {
            JiraApi.getUsetData().let {
                myEmailAddress = it.emailAddress
                document.getElementById("myDisplayName")?.textContent = "${it.displayName} (${it.emailAddress})"
            }
        }
    }

    private fun fetchEntries() {
        val startDate = startPicker.getISOString()
        val endDate = endPicker.getISOString()
        localStorage.setItem("jiggl.last-date", startDate)
        localStorage.setItem("jiggl.last-end-date", endDate)
        document.getElementById("error")?.apply {
            textContent = ""
            removeClass("error")
        }

        logs.clear()
        GlobalScope.launch {
            val entries = TogglApi.getTimeEntries(startDate, endDate).reversed()
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
                        dateKey = entry.start.toDateString()
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

            renderEntries(logs)
        }
    }

    private fun submitEntries() {
        logs.forEach {
            if (!it.submit) return@forEach

            val checkboxElement = document.getElementById(it.id.toString()) as? HTMLInputElement
            val commentElement = document.getElementById("comment-${it.id}") as? HTMLInputElement
            val resultElement = document.getElementById("result-${it.id}")?.apply {
                textContent = "Pending..."
                addClass("info")
            }

            val input = LogWorkInput(
                comment = commentElement?.value.orEmpty(),
                timeSpentSeconds = it.timeSpentInt,
                started = it.started
            )

            GlobalScope.launch {
                JiraApi.logWork(it.issue, input).let { status ->
                    if (status.isSuccess()) {
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

    private suspend fun renderEntries(logs: List<WorkLog>) {
        val table = document.create.tbody()

        logs.forEach {
            table.append.tr {
                td {
                    if (it.timeSpentInt > 0) {
                        input {
                            type = InputType.checkBox
                            checked = true
                            id = it.id.toString()
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
            }
        }

        val totalTime = logs.fold(0, { acc, log -> acc + log.timeSpentInt })
        table.append.tr {
            td(); td(); td()
            td { b { text("TOTAL") } }
            td { text(totalTime.toString().toHHMM()) }
        }

        document.getElementById("toggle-entries")?.innerHTML = table.innerHTML

        document.querySelectorAll("input[type=\"checkbox\"]").asList().forEach {
            (it as HTMLInputElement).onchange = { _ ->
                logs.find { l -> it.id == l.id.toString() }
                    ?.apply { submit = it.checked }
            }
        }

        logs.forEach { log ->

            GlobalScope.launch {
                JiraApi.getWorklog(log.issue)?.worklogs?.forEach { worklog ->
                    if (myEmailAddress == worklog.author.emailAddress) {
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
                                value = worklog.comment
                                disabled = true
                                log.submit = false
                            }
                        }
                    }
                }
            }
        }
    }
}