package api

import api.models.JiraUser
import api.models.LogWorkInput
import api.models.JiraWorklog
import io.ktor.client.HttpClient
import io.ktor.client.engine.js.Js
import io.ktor.client.features.*
import io.ktor.client.features.json.JsonFeature
import io.ktor.client.features.json.serializer.KotlinxSerializer
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
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
                    url.protocol = it.protocol
                    url.encodedPath = it.encodedPath + url.encodedPath
//                    header("X-Atlassian-Token", "nocheck") // may be needed, not sure yet
//                    header("Access-Control-Allow-Origin", "*")
                }
                install(JsonFeature) {
                    serializer = KotlinxSerializer(Json {
                        ignoreUnknownKeys = true
                    })
                }
                addDefaultResponseValidation()
            }
        }
    }

    /**
     * Returns JIRA user info.
     */
    suspend fun getUserData(serverHost: String): JiraUser =
        client.get(host = Url(serverHost).let { it.host + it.encodedPath }, path = "/rest/api/2/myself")

    /**
     * Logs work to Jira.
     */
    suspend fun logWork(serverHost: String, issue: String, log: LogWorkInput): HttpStatusCode {
        val response = client.post<HttpResponse>(
            host = Url(serverHost).let { it.host + it.encodedPath },
            path = "/rest/api/latest/issue/$issue/worklog"
        ) {
            header("Content-Type", "application/json")
            body = log
        }
        return response.status
    }

    /**
     * Gets worklog for given Jira task.
     */
    suspend fun getWorklog(serverHost: String, issue: String): JiraWorklog =
        client.get(
            host = Url(serverHost).let { it.host + it.encodedPath },
            path = "/rest/api/latest/issue/$issue/worklog"
        )
}
