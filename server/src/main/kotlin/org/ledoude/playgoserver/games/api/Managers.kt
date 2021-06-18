package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono
import reactor.core.publisher.Sinks

class GenericApiManager<T>(
    val protocol: Api.Protocol<T>,
    val eventProcessor: Api.Processor<T>,
    val pubSub: PubSub<T>,
) : Api.Manager {
    val logger = LoggerFactory.getLogger(this::class.java)

    override fun register(session: WebSocketSession): Mono<Void> {
        logger.info("Registering WebSocketSession ${session.id}")
        val unicast = Sinks.many().unicast().onBackpressureBuffer<T>()
        val subscription = pubSub.listen()
            .doOnNext {
                logger.debug("unicast emitting $it")
                unicast.tryEmitNext(it)
            }
        val castMessages: Flux<WebSocketMessage> = unicast.asFlux()
            .doOnNext { logger.debug("unicast receiving $it") }
            .flatMap { protocol.encode(session, it) }
        val sending = session.send(castMessages)
        val receiving = session.receive()
            .flatMap { protocol.decode(session, it) }
            .flatMap(eventProcessor::process)
            .flatMap(pubSub::publish)
        return Flux.merge(receiving, sending, subscription).then()
    }
}
