package org.ledoude.playgoserver.games.config

import org.ledoude.playgoserver.games.api.BaseApiManagerFactory
import org.ledoude.playgoserver.games.api.GameWebSocketHandler
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.redis.core.ReactiveRedisOperations
import org.springframework.data.redis.listener.ReactiveRedisMessageListenerContainer
import org.springframework.web.reactive.HandlerMapping
import org.springframework.web.reactive.config.EnableWebFlux
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping

@Configuration
@EnableWebFlux
class Websockets() {


    @Bean
    fun handlerMapping(
        container: ReactiveRedisMessageListenerContainer,
        operations: ReactiveRedisOperations<String, String>
    ): HandlerMapping {
        val mapping = SimpleUrlHandlerMapping()
        mapping.urlMap = mapOf(
            "/games/{id}" to GameWebSocketHandler(BaseApiManagerFactory(
                container, operations
            ))
        )
        mapping.order = 1
        return mapping
    }
}