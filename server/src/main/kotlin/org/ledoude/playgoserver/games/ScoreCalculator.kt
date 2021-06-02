package org.ledoude.playgoserver.games

//TODO (le-doude): use https://en.wikipedia.org/wiki/Flood_fill to implement score counting at end game

//TODO (le-doude): use https://github.com/le-doude/score-estimator to get a score estimator

interface ScoreCalculator {
    fun count(board: Board): Map<Colors, Int>
}

