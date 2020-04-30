package api

import api.models.JiraUser
import api.models.LogWorkInput
import api.models.JiraWorklog
import io.ktor.client.HttpClient
import io.ktor.client.engine.js.Js
import io.ktor.client.features.defaultRequest
import io.ktor.client.features.json.JsonFeature
import io.ktor.client.features.json.serializer.KotlinxSerializer
import io.ktor.client.request.*
import io.ktor.client.response.HttpResponse
import io.ktor.client.response.readText
import io.ktor.http.HttpStatusCode
import io.ktor.http.Url
import io.ktor.http.isSuccess
import kotlinx.serialization.UnstableDefault
import kotlinx.serialization.json.Json

/**
 * JIRA related endpoints.
 *
 * https://docs.atlassian.com/software/jira/docs/api/REST/8.5.4/
 */
object JiraApi {

    private lateinit var client: HttpClient

    /**
     * Initializes HttpClient with base URL.
     */
    fun init(baseUrl: String) {
        Url(baseUrl).let {
            client = HttpClient(Js) {
                defaultRequest {
                    host = it.host
                    url.protocol = it.protocol
//                    header("X-Atlassian-Token", "nocheck") // may be needed, not sure yet
//                    header("Access-Control-Allow-Origin", "*")
                }
                install(JsonFeature) {
                    serializer = KotlinxSerializer(Json.nonstrict)
                }
            }
        }
    }

    /**
     * Returns JIRA user info.
     */
    suspend fun getUsetData(): JiraUser =
        client.get(path = "/rest/api/2/myself")

    /**
     * Logs work to Jira.
     */
    suspend fun logWork(issue: String, log: LogWorkInput): HttpStatusCode {
        val response = client.post<HttpResponse>(path = "/rest/api/latest/issue/$issue/worklog") {
            header("Content-Type", "application/json")
            body = log
        }
        return response.status
    }

    /**
     * Gets worklog for given Jira task.
     */
    @UnstableDefault
    suspend fun getWorklog(issue: String): JiraWorklog? {
        val response = client.get<HttpResponse>(path = "/rest/api/latest/issue/$issue/worklog")
        return if (response.status.isSuccess()) {
            Json.parse(JiraWorklog.serializer(), response.readText())
        } else {
            null
        }
    }
}