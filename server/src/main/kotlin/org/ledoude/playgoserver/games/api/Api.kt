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

    @JsonSubTypes(
        JsonSubTypes.Type(Text::class),
        JsonSubTypes.Type(GameState::class),
        JsonSubTypes.Type(Echo::class),
        JsonSubTypes.Type(ClientDisconnect::class),
        JsonSubTypes.Type(ClientConnect::class),
    )
    @JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "event"
    )
    interface Event{
        interface GameAction : Event {
            fun process(context: GameContext): Flux<Api.Event>
        }
        interface ChatAction : Event {
            fun process(context: ChatContext): Flux<Api.Event>
        }
    }
}