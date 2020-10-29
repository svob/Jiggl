package utils.extensions

import org.w3c.dom.HTMLElement

/**
 * Returns true when this element display style is not `none` , false otherwise.
 *
 * ```
 * if (view.isVisible) {
 *     // Behavior...
 * }
 * ```
 *
 * Setting this property to true sets the display style to `inline`, false to `none`.
 *
 * ```
 * view.isVisible = true
 * ```
 */
var HTMLElement.isVisible: Boolean
    get() = this.style.display != "none"
    set(value) { style.display = if (value) "inline" else "none" }