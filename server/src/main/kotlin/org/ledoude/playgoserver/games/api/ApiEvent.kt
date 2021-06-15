package org.ledoude.playgoserver.games.api

import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonSubTypes.Type
import com.fasterxml.jackson.annotation.JsonTypeInfo
import org.ledoude.playgoserver.games.Game

@JsonTypeInfo(
    use = JsonTypeInfo.Id.NAME,
    include = JsonTypeInfo.As.PROPERTY,
    property = "event"
)
@JsonSubTypes(
    Type(Text::class, name = "text"),
    Type(GameState::class, name = "gamestate"),
)
interface ApiEvent {
    fun process(game: Game)
}

data class Text(val text: String) : ApiEvent {
    override fun process(game: Game) {
        println("Message: $text")
    }
}

data class GameState(val state: String) : ApiEvent {
    override fun process(game: Game) {}
}

