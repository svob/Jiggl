package api.serializers

import kotlinx.serialization.*
import kotlinx.serialization.internal.StringDescriptor
import utils.extensions.toISO8601String
import kotlin.js.Date

@Serializer(forClass = Date::class)
object DateSerializer: KSerializer<Date> {
    override val descriptor: SerialDescriptor = StringDescriptor.withName("Date")

    override fun deserialize(decoder: Decoder): Date =
        Date(decoder.decodeString())


    override fun serialize(encoder: Encoder, obj: Date) {
        encoder.encodeString(obj.toISO8601String())
    }
}