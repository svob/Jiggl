package popup.models

import kotlin.js.Date
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull

class WorkLogTest {

    val testWorklog = WorkLog(
        id = -1,
        issue = "TST-1",
        description = "Implementation of template",
        comment = "Implementation of template",
        started = Date(),
        dateKey = "",
        timeSpent = "",
        timeSpentInt = 0,
        submit = false,
    )

    @Test
    fun fromTemplate() {
        val entryDescription = "TST-1 Implementation of template"
        val template = "(?<issue>.*-\\d*) (?<desc>.*)"
        val log = WorkLog.fromTemplate(entryDescription, template)

        ensureLogEqual(testWorklog, log)
    }

    @Test
    fun fromTemplate2() {
        val entryDescription = "TST-1: Implementation of template"
        val template = "(?<issue>.*-\\d*): (?<desc>.*)"
        val log = WorkLog.fromTemplate(entryDescription, template)

        ensureLogEqual(testWorklog, log)
    }

    @Test
    fun fromTemplate3() {
        val entryDescription = "TST-1 - Implementation of template"
        val template = "(?<issue>.*-\\d*) - (?<desc>.*)"
        val log = WorkLog.fromTemplate(entryDescription, template)

        ensureLogEqual(testWorklog, log)
    }

    @Test
    fun fromTemplate_should_return_null() {
        val entryDescription = "Something"
        val template = "(?<issue>.*-\\d*) (?<desc>.*)"
        val log = WorkLog.fromTemplate(entryDescription, template)

        assertNull(log)
    }

    private fun ensureLogEqual(expected: WorkLog, actual: WorkLog?) {
        assertEquals(expected.id, actual?.id)
        assertEquals(expected.issue, actual?.issue)
        assertEquals(expected.description, actual?.description)
        assertEquals(expected.comment, actual?.comment)
        assertEquals(expected.dateKey, actual?.dateKey)
        assertEquals(expected.timeSpent, actual?.timeSpent)
        assertEquals(expected.timeSpentInt, actual?.timeSpentInt)
        assertEquals(expected.submit, actual?.submit)
    }
}