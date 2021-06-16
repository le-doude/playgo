package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.ReactiveRedisOperations
import org.springframework.data.redis.listener.ChannelTopic
import org.springframework.data.redis.listener.ReactiveRedisMessageListenerContainer
import org.springframework.web.reactive.socket.WebSocketMessage
import org.springframework.web.reactive.socket.WebSocketSession
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono
import reactor.core.publisher.Sinks
import reactor.core.scheduler.Schedulers
import java.util.*


interface ApiManagerFactory {

    fun make(id: UUID): ApiManager
}

class BaseApiManagerFactory(
    val redisMessageListenerContainer: ReactiveRedisMessageListenerContainer,
    val redisOps: ReactiveRedisOperations<String, String>,
) : ApiManagerFactory {
    override fun make(id: UUID): ApiManager {
        return BaseApiManager(id, redisMessageListenerContainer, redisOps)
    }

}

interface ApiManager {
    fun manage(session: WebSocketSession): Mono<Void>
}

class BaseApiManager(
    val gameId: UUID,
    val redisMessageListenerContainer: ReactiveRedisMessageListenerContainer,
    val redisOps: ReactiveRedisOperations<String, String>,
) : ApiManager {

    companion object {
        val log = LoggerFactory.getLogger(this::class.java)
    }

    override fun manage(session: WebSocketSession): Mono<Void> {
        log.info("managing $session")
        val topicStr = "game::$gameId"
        val uniCast = Sinks.many().unicast().onBackpressureBuffer<WebSocketMessage>()
        val redisSub = redisMessageListenerContainer.receive(ChannelTopic(topicStr))
            .doOnNext { uniCast.tryEmitNext(session.textMessage(it.message)) }
        val sndMsg = session.send(uniCast.asFlux())
        val recMsg = session.receive()
            .flatMap { broadcast(topicStr, it) }
        return Flux.merge(
            recMsg, sndMsg, redisSub
        ).then()
    }

    private fun broadcast(topicStr: String, it: WebSocketMessage): Mono<Void> {
        return redisOps.convertAndSend(topicStr, "ECHO: ${it.payloadAsText}")
            .then()
    }
}

