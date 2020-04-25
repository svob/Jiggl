import api.JiraApi
import api.TogglApi
import background.Background
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import options.Options
import popup.Popup
import kotlin.browser.window

fun main() = App().run()

class App {

    fun run() {
        GlobalScope.launch(Dispatchers.Main) {
            val prefs = AppPreferences.getPreferences()
            JiraApi.init(prefs.jiraUrl)
            TogglApi.init(prefs.togglApiToken)

            when (window.location.pathname) {
                "/_generated_background_page.html" -> Background().main()
                "/html/popup.html" -> Popup().main()
                "/html/options.html" -> Options().main()
            }
        }
    }
}