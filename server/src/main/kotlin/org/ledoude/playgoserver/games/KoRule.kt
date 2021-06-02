package org.ledoude.playgoserver.games

interface KoRule {
    fun determineKo(board: Board, lastMove: Pair<Board.Position, Colors>): Board.Position?
}