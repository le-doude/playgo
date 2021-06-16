package org.ledoude.playgoserver.games.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.redis.connection.ReactiveRedisConnectionFactory
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory
import org.springframework.data.redis.listener.ReactiveRedisMessageListenerContainer

@Configuration
class Redis {
//    @Bean
//    fun connectionFactory(
//        @Value("\${spring.redis.host:localhost}") redisHost: String,
//        @Value("\${spring.redis.port:6379}") redisPort: Int
//    ): ReactiveRedisConnectionFactory {
//        return LettuceConnectionFactory(redisHost, redisPort)
//    }

    @Bean
    fun listenerContainer(connectionFactory: ReactiveRedisConnectionFactory): ReactiveRedisMessageListenerContainer {
        return ReactiveRedisMessageListenerContainer(connectionFactory)
    }
}