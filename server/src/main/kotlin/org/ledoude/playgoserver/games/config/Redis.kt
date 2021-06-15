package org.ledoude.playgoserver.games.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration

//@Configuration
class Redis {
    @Value("\${spring.redis.host}")
    lateinit var redisHost: String

    @Value("\${spring.redis.port}")
    lateinit var redisPort: String
}