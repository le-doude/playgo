package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import reactor.core.publisher.Flux

class NoopProcessor : Api.Processor<Api.Event> {

    val logger = LoggerFactory.getLogger(this::class.java)

    override fun process(event: Api.Event): Flux<Api.Event> {
        logger.debug("Processing $event")
        return Flux.just(Echo(event), Text("separator"), Echo(event))
    }
}