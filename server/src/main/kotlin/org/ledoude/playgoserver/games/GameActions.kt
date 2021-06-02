package org.ledoude.playgoserver.games

import java.util.*

interface GameAction {
    val id: UUID
    val gameId: UUID
    val turn: Int
    val player: UUID
}

data class PlayAction(
    override val id: UUID,
    override val gameId: UUID,
    override val turn: Int,
    override val player: UUID,
    val color: String,
    val position: Board.Position
) : GameAction

data class PassAction(
    override val id: UUID,
    override val gameId: UUID,
    override val turn: Int,
    override val player: UUID
) : GameAction

data class ResignAction(
    override val id: UUID,
    override val gameId: UUID,
    override val turn: Int,
    override val player: UUID
) : GameAction