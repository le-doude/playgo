package org.ledoude.playgoserver.games

interface Rule {
    //TODO("https://senseis.xmp.net/?RulesOfGo")
    fun findKo(state: Game.State): Game.State
    fun isRepeated(state: Game.State): Game.State
    fun score(state: Game.State): Game.State
}
