package org.ledoude.playgoserver.games

import kotlin.random.Random

interface Game {
    fun place(position: Board.Position, player: Player): State
    fun resign(player: Player): State
    fun pass(player: Player): State
    fun counting(): State
    fun estimate(nextPlayer: Player): State
    fun state(): String

    interface State {}
}

class FakeGame : Game {
    override fun place(position: Board.Position, player: Player): Game.State {
        TODO("Not yet implemented")
    }

    override fun resign(player: Player): Game.State {
        TODO("Not yet implemented")
    }

    override fun pass(player: Player): Game.State {
        TODO("Not yet implemented")
    }

    override fun counting(): Game.State {
        TODO("Not yet implemented")
    }

    override fun estimate(nextPlayer: Player): Game.State {
        TODO("Not yet implemented")
    }

    override fun state(): String {
        return Random(System.currentTimeMillis()).nextBytes(16).decodeToString()
    }

}