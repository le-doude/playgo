package org.ledoude.playgoserver.games.api

import org.ledoude.playgoserver.games.FakeGame
import java.util.*

abstract class GameProcessor(val gameId: UUID) {
    abstract fun process(event: ApiEvent): ApiEvent?
}

class TextBackProcessor(gameId: UUID) : GameProcessor(gameId) {
    override fun process(event: ApiEvent): ApiEvent? {
        val game = FakeGame()
        event.process(game)
        return GameState(game.state())
    }
}