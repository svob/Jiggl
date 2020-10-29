package utils.extensions

import kotlinx.browser.window
import kotlin.math.floor

/**
 * TODO
 */
fun String.ellipsize(max: Int): String =
    if (length > max) "${substring(0, max)}..." else this

/**
 * TODO
 */
fun String.toHHMMSS(): String {
    val secNum = this.toInt()
    val hours = floor(secNum / 3600f)
    val minutes = floor((secNum - (hours * 3600)) / 60)
    val seconds = secNum - (hours * 3600) - (minutes * 60)

    return "${hours.toString().padStart(2, '0')}h " +
            "${minutes.toString().padStart(2, '0')}m " +
            "${seconds.toString().padStart(2, '0')}s"
}

/**
 * TODO
 */
fun String.toHHMM(): String {
    val secNum = this.toInt()
    val hours = floor(secNum / 3600f)
    val minutes = floor((secNum - (hours * 3600)) / 60)

    return "${hours.toString().padStart(2, '0')}h " +
            "${minutes.toString().padStart(2, '0')}m"
}

/**
 * TODO
 */
fun String.toHH_MM(): String {
    val secNum = this.toInt()
    val hours = floor(secNum / 3600f)
    val minutes = floor((secNum - (hours * 3600)) / 60)

    return "${hours.toString().padStart(2, '0')}:" +
            minutes.toString().padStart(2, '0')
}

fun String.toBase64(): String =
    window.btoa(this)