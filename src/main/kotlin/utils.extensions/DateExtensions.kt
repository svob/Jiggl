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