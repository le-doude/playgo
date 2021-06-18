package org.ledoude.playgoserver.games.api

data class Text(val text: String) : Api.Event {
}

data class GameState(val state: String) : Api.Event {
}

data class Echo(val event: Api.Event) : Api.Event {

}
