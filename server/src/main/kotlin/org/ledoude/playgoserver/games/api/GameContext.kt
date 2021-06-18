package org.ledoude.playgoserver.games.api

import org.ledoude.playgoserver.games.Board
import org.ledoude.playgoserver.games.Colors
import reactor.core.publisher.Flux

open class GameContext {
    fun play(color: Colors, pos: Board.Position): Flux<Api.Event> {
        return Flux.empty()
    }

    fun pass(color: Colors): Flux<Api.Event> {
        return Flux.empty()
    }

    fun resign(color: Colors): Flux<Api.Event> {
        return Flux.empty()
    }
}
