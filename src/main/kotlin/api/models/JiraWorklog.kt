package api.models


import api.serializers.DateSerializer
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.Date

@ExperimentalSerializationApi
@Serializable
data class JiraWorklog(
    @SerialName("maxResults")
    val maxResults: Int,
    @SerialName("startAt")
    val startAt: Int,
    @SerialName("total")
    val total: Int,
    @SerialName("worklogs")
    val worklogs: List<Worklog>
) {
    @ExperimentalSerializationApi
    @Serializable
    data class Worklog(
        @SerialName("author")
        val author: Author,
        @SerialName("comment")
        val comment: String,
        @SerialName("created")
        @Serializable(with = DateSerializer::class)
        val created: Date,
        @SerialName("id")
        val id: String,
        @SerialName("issueId")
        val issueId: String,
        @SerialName("self")
        val self: String,
        @SerialName("started")
        @Serializable(with = DateSerializer::class)
        val started: Date,
        @SerialName("timeSpent")
        val timeSpent: String,
        @SerialName("timeSpentSeconds")
        val timeSpentSeconds: Int,
        @SerialName("updateAuthor")
        val updateAuthor: UpdateAuthor,
        @SerialName("updated")
        @Serializable(with = DateSerializer::class)
        val updated: Date
    ) {
        @Serializable
        data class Author(
            @SerialName("active")
            val active: Boolean,
            @SerialName("avatarUrls")
            val avatarUrls: AvatarUrls,
            @SerialName("displayName")
            val displayName: String,
            @SerialName("emailAddress")
            val emailAddress: String,
            @SerialName("key")
            val key: String,
            @SerialName("name")
            val name: String,
            @SerialName("self")
            val self: String,
            @SerialName("timeZone")
            val timeZone: String
        ) {
            @Serializable
            data class AvatarUrls(
                @SerialName("16x16")
                val x16: String,
                @SerialName("24x24")
                val x24: String,
                @SerialName("32x32")
                val x32: String,
                @SerialName("48x48")
                val x48: String
            )
        }

        @Serializable
        data class UpdateAuthor(
            @SerialName("active")
            val active: Boolean,
            @SerialName("avatarUrls")
            val avatarUrls: AvatarUrls,
            @SerialName("displayName")
            val displayName: String,
            @SerialName("emailAddress")
            val emailAddress: String,
            @SerialName("key")
            val key: String,
            @SerialName("name")
            val name: String,
            @SerialName("self")
            val self: String,
            @SerialName("timeZone")
            val timeZone: String
        ) {
            @Serializable
            data class AvatarUrls(
                @SerialName("16x16")
                val x16: String,
                @SerialName("24x24")
                val x24: String,
                @SerialName("32x32")
                val x32: String,
                @SerialName("48x48")
                val x48: String
            )
        }
    }
}