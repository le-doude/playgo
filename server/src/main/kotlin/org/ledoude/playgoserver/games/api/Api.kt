package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono

interface Api {
    interface Processor<T> {
        fun process(it: T): Flux<T>
    }

    interface Protocol<T> {
        fun encode(session: WebSocketSession, it: T): Flux<WebSocketMessage>
        fun decode(session: WebSocketSession, messages: WebSocketMessage): Flux<T>
    }

    interface Manager {
        fun register(session: WebSocketSession): Mono<Void>
    }

    @JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "event"
    )
    @JsonSubTypes(
        JsonSubTypes.Type(Text::class, name = "text"),
        JsonSubTypes.Type(GameState::class, name = "gamestate"),
        JsonSubTypes.Type(Echo::class, name = "echo"),
    )
    interface Event{}
}