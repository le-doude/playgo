package org.ledoude.playgoserver

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class PlayGoServerApplication

fun main(args: Array<String>) {
    runApplication<PlayGoServerApplication>(*args)
}
