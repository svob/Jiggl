package api.models

import api.serializers.DateSerializer
import kotlinx.serialization.*
import kotlin.js.Date

@Serializable
data class LogWorkInput(
    val comment: String,
    val timeSpentSeconds: Int,
    @Serializable(with = DateSerializer::class)
    val started: Date
)