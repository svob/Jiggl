package utils.extensions

import kotlin.test.Test
import kotlin.test.assertEquals

class StringExtensionsTest {

    @Test
    fun ellipsize() {
        assertEquals("123456...", "1234567890wregw".ellipsize(6))
    }

    @Test
    fun toHHMMSS() {
        assertEquals("01h 56m 36s", "6996".toHHMMSS())
    }

    @Test
    fun toHHMM() {
        assertEquals("01h 56m", "6996".toHHMM())
    }

    @Test
    fun toHH_MM() {
        assertEquals("01:56", "6996".toHH_MM())
    }
}