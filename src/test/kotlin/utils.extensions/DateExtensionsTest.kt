package utils.extensions

import kotlin.js.Date
import kotlin.test.Test
import kotlin.test.assertEquals

class DateExtensionsTest {

    @Test
    fun toISO8601String() {
        assertEquals("2020-04-20T21:51:19.000+0200", Date("2020-04-20T21:51:19+00:00").toISO8601String())
    }

    @Test
    fun toDDMM() {
        assertEquals("Apr 12", Date("2020-04-12").toDDMM())
    }
}