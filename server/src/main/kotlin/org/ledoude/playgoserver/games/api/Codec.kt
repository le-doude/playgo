package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue


interface Codec<T> {
    fun encode(event: T): String
    fun decode(eventStr: String): T
}

class JsonApiEventCodec(val objectMapper: ObjectMapper) : Codec<Api.Event> {
    override fun encode(event: Api.Event): String {
        return objectMapper.writeValueAsString(event)
    }

    override fun decode(eventStr: String): Api.Event {
        return objectMapper.readValue(eventStr)
    }
}