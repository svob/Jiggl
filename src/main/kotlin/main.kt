import chrome.tabs.ExecuteScriptDetails
import chrome.tabs.executeScript
import options.Options
import kotlin.browser.document
import kotlin.browser.window

@Suppress("UNCHECKED_CAST_TO_EXTERNAL_INTERFACE")
fun ExecuteScriptDetails(details: ExecuteScriptDetails.() -> Unit) = (js("{}") as ExecuteScriptDetails).apply(details)

fun main() {
//    executeScript(details = ExecuteScriptDetails {
//        file = "parser.js"
//    })

    when (window.location.pathname) {
        "/_generated_background_page.html" -> background.main()
        "/html/popup.html" -> popup.main()
        "/html/options.html" -> Options().main()
    }
}