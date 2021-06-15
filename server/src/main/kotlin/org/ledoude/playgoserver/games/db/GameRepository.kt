package org.ledoude.playgoserver.games.db

import org.ledoude.playgoserver.games.Game
import java.util.*

interface GameRepository {

    fun get(id: UUID): Game

}
