package api.models


import api.serializers.DateSerializer
import kotlinx.serialization.*
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.descriptors.*
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlin.js.Date

@Serializable
data class TogglTimeEntry(
    @SerialName("at")
    @Serializable(with = DateSerializer::class)
    val at: Date,
    @SerialName("billable")
    val billable: Boolean,
    @SerialName("description")
    val description: String = "",
    @SerialName("duration")
    val duration: Int = 0,
    @SerialName("duronly")
    val duronly: Boolean,
    @SerialName("guid")
    val guid: String,
    @SerialName("id")
    val id: Int,
    @SerialName("pid")
    val pid: Int? = null,
    @SerialName("start")
    @Serializable(with = DateSerializer::class)
    val start: Date,
    @SerialName("stop")
    @Serializable(with = DateSerializer::class)
    val stop: Date? = null,
    @SerialName("uid")
    val uid: Int,
    @SerialName("wid")
    val wid: Int
)

@Serializable
data class TogglTimeEntryList(
    val items: List<TogglTimeEntry>
) {
    @Serializer(TogglTimeEntryList::class)
    companion object {
        @ExperimentalSerializationApi
        @InternalSerializationApi
        override val descriptor: SerialDescriptor = buildSerialDescriptor("TogglTimeEntryList", StructureKind.LIST)

        override fun deserialize(decoder: Decoder): TogglTimeEntryList =
            TogglTimeEntryList(ListSerializer(TogglTimeEntry.serializer()).deserialize(decoder))

        override fun serialize(encoder: Encoder, value: TogglTimeEntryList) =
            ListSerializer(TogglTimeEntry.serializer()).serialize(encoder, value.items)
    }
}