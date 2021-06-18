package org.ledoude.playgoserver.games.config

import org.ledoude.playgoserver.games.api.GameWebSocketHandler
import org.ledoude.playgoserver.games.api.ManagerBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.reactive.HandlerMapping
import org.springframework.web.reactive.config.EnableWebFlux
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping

@Configuration
@EnableWebFlux
class Websockets {
    @Bean
    fun handlerMapping(
        managerBuilder: ManagerBuilder,
    ): HandlerMapping {
        val mapping = SimpleUrlHandlerMapping()
        mapping.urlMap = mapOf(
            "/games/{id}" to GameWebSocketHandler(managerBuilder)
        )
        mapping.order = 1
        return mapping
    }
}