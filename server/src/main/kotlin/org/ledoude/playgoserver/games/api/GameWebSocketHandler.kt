package org.ledoude.playgoserver.games.api

import org.springframework.web.reactive.socket.WebSocketHandler
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import org.springframework.web.util.UriTemplate
import reactor.core.publisher.Flux
import reactor.core.publisher.FluxSink
import reactor.core.publisher.Mono
import java.time.Duration
import java.util.*

class GameWebSocketHandler(val processorProvider: GameProcessorProvider, val codec: Codec) : WebSocketHandler {
    private val pathTemplate = UriTemplate("/games/{id}")

    override fun handle(session: WebSocketSession): Mono<Void> {
        val response: Flux<WebSocketMessage> = session.receive()
            .map { with(makeProcessor(session)) { process(codec.decode(it.payloadAsText)) } }
            .mapNotNull { event -> event?.let { session.textMessage(codec.encode(it)) } }
        return session.send(response)
    }

    private fun makeProcessor(session: WebSocketSession): GameProcessor {
        val id: UUID = extractId(session)
        return processorProvider.get(id)
    }

    private fun extractId(session: WebSocketSession): UUID {
        val match = pathTemplate.match(session.handshakeInfo.uri.rawPath)
        return UUID.fromString(match["id"])
    }
}

