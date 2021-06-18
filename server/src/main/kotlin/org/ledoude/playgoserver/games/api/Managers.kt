package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono
import reactor.core.publisher.Sinks
import java.util.*

class GenericApiManager(
    val protocol: Api.Protocol<Api.Event>,
    val eventProcessor: Api.Processor<Api.Event>,
    val pubSub: PubSub<Api.Event>,
) : Api.Manager {
    val logger = LoggerFactory.getLogger(this::class.java)

    override fun register(session: WebSocketSession): Mono<Void> {
        logger.info("Registering WebSocketSession ${session.id}")
        val user = UUID.randomUUID()
        val unicast = Sinks.many().unicast().onBackpressureBuffer<Api.Event>()
        val subscription = pubSub.listen()
            .map { unicast.tryEmitNext(it) }
        val castMessages: Flux<WebSocketMessage> = unicast.asFlux()
            .flatMap { protocol.encode(session, it) }
        val sending = session.send(castMessages)
        val receiving = session.receive()
            .flatMap { protocol.decode(session, it) }
            .flatMap(eventProcessor::process)
            .flatMap(pubSub::publish)
            .doOnSubscribe { pubSub.publish(ClientConnect(session.id, user)).subscribe() }
            .doFinally { pubSub.publish(ClientDisconnect(session.id, user)).subscribe() }
        return Flux.merge(
            receiving,
            sending,
            subscription).then()
    }
}
