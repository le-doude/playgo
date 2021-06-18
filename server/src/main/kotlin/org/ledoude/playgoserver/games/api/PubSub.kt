package org.ledoude.playgoserver.games.api

import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.ReactiveStringRedisTemplate
import org.springframework.data.redis.listener.ChannelTopic
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono

interface PubSub<T> {
    val channel: String

    fun listen(): Flux<T>

    fun publish(message: T): Mono<Void>

    companion object {
        fun <X> redis(channel: String, codec: Codec<X>, redisTemplate: ReactiveStringRedisTemplate): PubSub<X> {
            return RedisPubSub(channel, redisTemplate, codec)
        }
    }

}

class RedisPubSub<T>(
    override val channel: String,
    val redisTemplate: ReactiveStringRedisTemplate,
    val codec: Codec<T>,
) : PubSub<T> {

    val logger = LoggerFactory.getLogger(this::class.java)

    override fun listen(): Flux<T> {
        return redisTemplate.listenTo(ChannelTopic(channel))
            .doOnNext { logger.debug("Received ${it.message}") }
            .map { codec.decode(it.message) }
    }

    override fun publish(message: T): Mono<Void> {
        return redisTemplate.convertAndSend(channel, codec.encode(message))
            .doOnSuccess { logger.debug("Published $message") }
            .then()
    }
}
