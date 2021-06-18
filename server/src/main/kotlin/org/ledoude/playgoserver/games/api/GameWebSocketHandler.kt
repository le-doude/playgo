package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.data.redis.core.ReactiveStringRedisTemplate
import org.springframework.stereotype.Component
import org.springframework.web.reactive.socket.WebSocketHandler
import org.springframework.web.reactive.socket.WebSocketSession
import org.springframework.web.util.UriTemplate
import reactor.core.publisher.Mono
import java.util.*

class GameWebSocketHandler(val factory: ManagerBuilder) : WebSocketHandler {
    private val pathTemplate = UriTemplate("/games/{id}")

    override fun handle(session: WebSocketSession): Mono<Void> {
        val id: UUID = extractId(session)
        val manager = factory.build(id)
        return manager.register(session)
    }

    private fun extractId(session: WebSocketSession): UUID {
        val match = pathTemplate.match(session.handshakeInfo.uri.rawPath)
        return UUID.fromString(match["id"])
    }
}

interface ManagerBuilder {
    fun build(uuid: UUID): Api.Manager
}

@Component
class DefaultGameManagerBuilder(val objectMapper: ObjectMapper, val redisTemplate: ReactiveStringRedisTemplate) :
    ManagerBuilder {
    override fun build(uuid: UUID): Api.Manager {
        return GenericApiManager(
            JsonApiEventProtocol(JsonApiEventCodec(objectMapper)),
            NoopProcessor(),
            RedisPubSub("game:$uuid", redisTemplate, JsonApiEventCodec(objectMapper)),
        )
    }
}

