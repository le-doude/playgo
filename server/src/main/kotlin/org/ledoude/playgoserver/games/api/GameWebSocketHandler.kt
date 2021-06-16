package org.ledoude.playgoserver.games.api

import org.reactivestreams.Subscriber
import org.springframework.web.reactive.socket.WebSocketHandler
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import org.springframework.web.util.UriTemplate
import reactor.core.publisher.Mono
import reactor.kotlin.core.publisher.toMono
import java.util.*

class GameWebSocketHandler(val factory: ApiManagerFactory) : WebSocketHandler {
    private val pathTemplate = UriTemplate("/games/{id}")

//    override fun handle(session: WebSocketSession): Mono<Void> {
//        val id: UUID = extractId(session)
//        val input = apiManager.input(session, id)
//
//        val pub = session.send(apiManager.output(session, id))
//
//        return session.receive()
//            .doOnNext(input::onNext)
//            .doOnError(input::onError)
//            .doOnComplete(input::onComplete)
//            .doOnSubscribe(input::onSubscribe)
//            .zipWith(pub).then()
//    }

    override fun handle(session: WebSocketSession): Mono<Void> {
        val id: UUID = extractId(session)
        val manager = factory.make(id)
        return manager.manage(session)
    }

    private fun extractId(session: WebSocketSession): UUID {
        val match = pathTemplate.match(session.handshakeInfo.uri.rawPath)
        return UUID.fromString(match["id"])
    }
}

