package utils.extensions

import kotlin.js.Date
import kotlin.math.abs

/**
 * Converts Date to ISO-8601 format that is used in Jira API.
 */
fun Date.toISO8601String(): String {
    val dateString = this.toISOString()
    val timeZone = this.getTimezoneOffset() / (-60)
    val sign = if (timeZone > 0) '+' else '-'
    val timeZoneString = sign + abs(timeZone).toString().padStart(2, '0') + "00"
    return dateString.replace("Z", timeZoneString)
}

/**
 * Converts date to string in format `month day` eg. Jan 12
 */
fun Date.toDDMM(): String {
    val monthNames = arrayOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    return "${monthNames[getMonth()]} ${getDate()}"
}

/**
 * Converts date to string in format `year month day` eg. 2021 Jan 12
 */
fun Date.toDDMMYY(): String {
    val monthNames = arrayOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    return "${getFullYear()} ${monthNames[getMonth()]} ${getDate()}"
}

/**
 * Check if the date is before other one.
 */
fun Date.isBefore(other: Date): Boolean =
    when {
        getFullYear() < other.getFullYear() -> true
        getFullYear() > other.getFullYear() -> false
        getMonth() < other.getMonth() -> true
        getMonth() > other.getMonth() -> false
        else -> getDate() < other.getDate()
    }

/**
 * Check if the date is after other one.
 */
fun Date.isAfter(other: Date): Boolean =
    when {
        getFullYear() > other.getFullYear() -> true
        getFullYear() < other.getFullYear() -> false
        getMonth() > other.getMonth() -> true
        getMonth() < other.getMonth() -> false
        else -> getDate() > other.getDate()
    }

/**
 * Adds specified days to the date.
 *
 * !! Doesn't take daylight savings into account !!
 */
fun Date.addDays(days: Int): Date =
    Date(getTime() + 864E5 * days)