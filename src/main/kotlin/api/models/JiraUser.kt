package api.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class JiraUser(
    @SerialName("active")
    val active: Boolean,
    @SerialName("applicationRoles")
    val applicationRoles: ApplicationRoles,
    @SerialName("avatarUrls")
    val avatarUrls: AvatarUrls,
    @SerialName("displayName")
    val displayName: String,
    @SerialName("emailAddress")
    val emailAddress: String,
    @SerialName("expand")
    val expand: String,
    @SerialName("groups")
    val groups: Groups,
    @SerialName("key")
    val key: String,
    @SerialName("locale")
    val locale: String,
    @SerialName("name")
    val name: String,
    @SerialName("self")
    val self: String,
    @SerialName("timeZone")
    val timeZone: String
) {
    @Serializable
    data class ApplicationRoles(
        @SerialName("items")
        val items: List<String>,
        @SerialName("size")
        val size: Int
    )

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

    @Serializable
    data class Groups(
        @SerialName("items")
        val items: List<String>,
        @SerialName("size")
        val size: Int
    )
}