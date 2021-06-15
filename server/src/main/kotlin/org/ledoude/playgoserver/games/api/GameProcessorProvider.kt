package org.ledoude.playgoserver.games.api

import java.util.*

interface GameProcessorProvider {
    fun get(id: UUID): GameProcessor
}

class TextBackGameProcessorProvider : GameProcessorProvider {
    override fun get(id: UUID): GameProcessor {
        return TextBackProcessor(id);
    }
}