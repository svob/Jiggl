package utils.extensions

import org.w3c.dom.HTMLInputElement
import kotlin.js.Date

fun HTMLInputElement.getISOString(): String = (this.valueAsDate as Date).toISOString()