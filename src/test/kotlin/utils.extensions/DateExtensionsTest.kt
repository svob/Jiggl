package utils.extensions

import kotlin.js.Date
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class DateExtensionsTest {

    @Test
    fun toISO8601String() {
        assertEquals("2020-04-20T21:51:19.000+0200", Date("2020-04-20T21:51:19+00:00").toISO8601String())
    }

    @Test
    fun toDDMM() {
        assertEquals("Apr 12", Date("2020-04-12").toDDMM())
    }

    @Test
    fun isBefore() {
        val d1 = Date("2020-04-24")
        val d2 = Date("2020-04-23")
        val d3 = Date("2020-03-24")
        val d4 = Date("2019-04-24")
        assertTrue { d2.isBefore(d1) }
        assertFalse { d1.isBefore(d2) }
        assertTrue { d3.isBefore(d1) }
        assertFalse { d1.isBefore(d3) }
        assertTrue { d4.isBefore(d1) }
        assertFalse { d1.isBefore(d4) }
        assertFalse { d1.isBefore(d1) }
    }

    @Test
    fun isAfter() {
        val d1 = Date("2020-04-24")
        val d2 = Date("2020-04-23")
        val d3 = Date("2020-03-24")
        val d4 = Date("2019-04-24")
        assertFalse { d2.isAfter(d1) }
        assertTrue { d1.isAfter(d2) }
        assertFalse { d3.isAfter(d1) }
        assertTrue { d1.isAfter(d3) }
        assertFalse { d4.isAfter(d1) }
        assertTrue { d1.isAfter(d4) }
        assertFalse { d1.isBefore(d1) }
    }
}