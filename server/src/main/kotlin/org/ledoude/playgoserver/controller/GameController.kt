package org.ledoude.playgoserver.controller

import org.ledoude.playgoserver.service.GameService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.Payload
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.PathVariable
import java.util.*

@Controller
class GameController {

    @Autowired
    lateinit var service: GameService

    @MessageMapping("/game/{:gameId}")
    fun onGameMessage(
        @PathVariable("gameId") gameId: UUID,
        @Payload event: GameEvent
    ) {
        service
    }

    data class GameEvent(val number: Int, val name: String, val message: String)
}