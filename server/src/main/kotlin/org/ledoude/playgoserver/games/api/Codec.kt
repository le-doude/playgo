package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import org.springframework.stereotype.Component
import org.springframework.stereotype.Service


interface Codec {
    fun encode(event: ApiEvent): String
    fun decode(eventStr: String): ApiEvent
}

class JsonCodec(val objectMapper: ObjectMapper) : Codec {
    override fun encode(event: ApiEvent): String {
        return objectMapper.writeValueAsString(event)
    }

    override fun decode(eventStr: String): ApiEvent {
        return objectMapper.readValue(eventStr)
    }
}