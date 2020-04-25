@file:JsQualifier("chrome.tabs")

package chrome.tabs

import kotlin.js.Promise

external fun executeScript(
    tabId: Int? = definedExternally,
    details: ExecuteScriptDetails
): Promise<Array<dynamic>>

external interface ExecuteScriptDetails {

    /**
     * JavaScript or CSS code to inject.
     *
     * Warning:
     * Be careful using the code parameter.
     * Incorrect use of it may open your extension to cross site scripting attacks.
     */
    var code: String?

    /** JavaScript or CSS file to inject. */
    var file: String?

    /**
     * If allFrames is true, implies that the JavaScript or CSS should be injected into all frames of current page.
     * By default, it's false and is only injected into the top frame.
     * If true and frameId is set, then the code is inserted in the selected frame and all of its child frames.
     */
    var allFrames: Boolean?

    /**
     * The frame where the script or CSS should be injected. Defaults to 0 (the top-level frame).
     * Since Chrome 39.
     */
    var frameId: Int?

    /**
     * If matchAboutBlank is true, then the code is also injected in about:blank and about:srcdoc frames if your extension has access to its parent document.
     * Code cannot be inserted in top-level about:-frames. By default it is false.
     * Since Chrome 39.
     */
    var matchAboutBlank: Boolean?

    /**
     * The soonest that the JavaScript or CSS will be injected into the tab. Defaults to "document_idle".
     */
    var runAt: String?
}