package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import reactor.core.publisher.Flux

class JsonApiEventProtocol(val codec: Codec<Api.Event>) : Api.Protocol<Api.Event> {
    val logger = LoggerFactory.getLogger(this::class.java)

    override fun encode(session: WebSocketSession, event: Api.Event): Flux<WebSocketMessage> {
        logger.debug("Encoding $event")
        return Flux.just(event).mapNotNull(codec::encode).map(session::textMessage)
    }

    override fun decode(session: WebSocketSession, msg: WebSocketMessage): Flux<Api.Event> {
        logger.debug("Decoding ${msg.payloadAsText}")
        return Flux.just(msg).mapNotNull { codec.decode(it.payloadAsText) }
    }
}