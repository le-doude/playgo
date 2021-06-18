package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.annotation.JsonTypeName
import org.ledoude.playgoserver.games.Board
import org.ledoude.playgoserver.games.Colors
import reactor.core.publisher.Flux
import java.util.*
import java.util.jar.Attributes
import kotlin.reflect.jvm.internal.impl.load.kotlin.JvmType

@JsonTypeName("text")
data class Text(val text: String) : Api.Event {}

@JsonTypeName("gamestate")
data class GameState(
    val board: String,
    val currentTurn: Colors,
    val kos: List<Board.Position>,
) : Api.Event {}

@JsonTypeName("client-disconnected")
data class ClientDisconnect(val session: String, val user: UUID) : Api.Event {}

@JsonTypeName("client-connected")
data class ClientConnect(val session: String, val user: UUID) : Api.Event {}

@JsonTypeName("echo")
data class Echo(val event: Api.Event) : Api.Event {}

@JsonTypeName("play")
data class Play(val player: Colors, val col: Int, val row: Int) : Api.Event.GameAction {
    override fun process(context: GameContext): Flux<Api.Event> {
        return context.play(player, Board.Position(col, row))
    }
}

@JsonTypeName("pass")
data class Pass(val player: Colors) : Api.Event.GameAction {
    override fun process(context: GameContext): Flux<Api.Event> {
        return context.pass(player)
    }
}

@JsonTypeName("resign")
data class Resign(val player: Colors) : Api.Event.GameAction {
    override fun process(context: GameContext): Flux<Api.Event> {
        return context.resign(player)
    }
}