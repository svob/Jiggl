package api.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TogglUserData(
    @SerialName("data")
    val `data`: Data,
    @SerialName("since")
    val since: Int
) {
    @Serializable
    data class Data(
        @SerialName("api_token")
        val apiToken: String,
        @SerialName("at")
        val at: String,
        @SerialName("beginning_of_week")
        val beginningOfWeek: Int,
//        @SerialName("clients")
//        val clients: List<Any>,
        @SerialName("created_at")
        val createdAt: String,
        @SerialName("date_format")
        val dateFormat: String,
        @SerialName("default_wid")
        val defaultWid: Int,
        @SerialName("duration_format")
        val durationFormat: String,
        @SerialName("email")
        val email: String,
        @SerialName("fullname")
        val fullname: String,
        @SerialName("id")
        val id: Int,
        @SerialName("image_url")
        val imageUrl: String,
        @SerialName("jquery_date_format")
        val jqueryDateFormat: String,
        @SerialName("jquery_timeofday_format")
        val jqueryTimeofdayFormat: String,
        @SerialName("language")
        val language: String,
        @SerialName("projects")
        val projects: List<Project>,
        @SerialName("retention")
        val retention: Int,
        @SerialName("store_start_and_stop_time")
        val storeStartAndStopTime: Boolean,
        @SerialName("tags")
        val tags: List<Tag>,
//        @SerialName("tasks")
//        val tasks: List<Any>,
        @SerialName("timeofday_format")
        val timeofdayFormat: String,
        @SerialName("timezone")
        val timezone: String,
        @SerialName("workspaces")
        val workspaces: List<Workspace>
    ) {
        @Serializable
        data class Project(
            @SerialName("active")
            val active: Boolean,
            @SerialName("at")
            val at: String,
            @SerialName("billable")
            val billable: Boolean,
            @SerialName("color")
            val color: String,
            @SerialName("id")
            val id: Int,
            @SerialName("name")
            val name: String,
            @SerialName("wid")
            val wid: Int
        )

        @Serializable
        data class Tag(
            @SerialName("id")
            val id: Int,
            @SerialName("name")
            val name: String,
            @SerialName("wid")
            val wid: Int
        )

        @Serializable
        data class Workspace(
            @SerialName("api_token")
            val apiToken: String,
            @SerialName("at")
            val at: String,
            @SerialName("default_currency")
            val defaultCurrency: String,
            @SerialName("default_hourly_rate")
            val defaultHourlyRate: Int,
            @SerialName("id")
            val id: Int,
            @SerialName("name")
            val name: String,
            @SerialName("projects_billable_by_default")
            val projectsBillableByDefault: Boolean,
            @SerialName("rounding")
            val rounding: Int,
            @SerialName("rounding_minutes")
            val roundingMinutes: Int
        )
    }
}