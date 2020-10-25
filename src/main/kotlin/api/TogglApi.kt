package api

import api.models.TogglTimeEntry
import api.models.TogglTimeEntryList
import api.models.TogglUserData
import io.ktor.client.HttpClient
import io.ktor.client.engine.js.Js
import io.ktor.client.features.*
import io.ktor.client.features.json.JsonFeature
import io.ktor.client.features.json.serializer.KotlinxSerializer
import io.ktor.client.request.*
import io.ktor.http.URLProtocol
import kotlinx.serialization.json.Json
import utils.extensions.toBase64
import kotlin.js.Date

/**
 * Toggl related endpoints.
 */
object TogglApi {

    private lateinit var client: HttpClient
    private lateinit var apiToken: String

    /**
     * Initializes HttpClient with base URL.
     */
    fun init(apiToken: String) {
        this.apiToken = apiToken
        client = HttpClient(Js) {
            defaultRequest {
                host = "www.toggl.com"
                url.protocol = URLProtocol.HTTPS
                header("Authorization", "Basic " + "${this@TogglApi.apiToken}:api_token".toBase64())
            }
            install(JsonFeature) {
                serializer = KotlinxSerializer(Json {
                    ignoreUnknownKeys = true
                })
            }
            HttpResponseValidator {
                validateResponse { response ->
                    when (response.status.value) {
                        in 300..399 -> throw RedirectResponseException(response)
                        in 400..499 -> throw ClientRequestException(response)
                        in 500..599 -> throw ServerResponseException(response)
                    }
                    if (response.status.value >= 600) {
                        throw ResponseException(response)
                    }
                }
            }
        }
    }

    /**
     * Get time entries for specified date range.
     *
     * @param startDate Start date in ISO format.
     * @param endDate End date in ISO format.
     */
    suspend fun getTimeEntries(startDate: Date, endDate: Date): List<TogglTimeEntry> =
        client.get<TogglTimeEntryList> {
            url { encodedPath = "/api/v8/time_entries?start_date=${startDate.toISOString()}&end_date=${endDate.toISOString()}" }
        }.items

    /**
     * Get toggl user data.
     */
    suspend fun getUserData(token: String): TogglUserData {
        apiToken = token
        return client.get(path = "/api/v8/me?with_related_data=true")
    }
}