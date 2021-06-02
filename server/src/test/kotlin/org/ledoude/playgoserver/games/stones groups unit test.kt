package org.ledoude.playgoserver.games

import io.mockk.mockk
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class `stones groups unit test` {

    @Test
    fun `a single stone has group containing only the stone itself`() {
        val stone = Stone(Colors.Black, mockk())
        assertThat(stone.group).isNotNull
        assertThat(stone.group.stones).containsExactly(stone)
    }

    @Test
    fun `two separate stones have different groups`() {
        val stone = Stone(Colors.Black, mockk())
        val stone2 = Stone(Colors.Black, mockk())
        assertThat(stone.group).isNotEqualTo(stone2.group)
    }

    @Test
    fun `after linking stones have same group`() {
        val stone = Stone(Colors.Black, mockk())
        val stone2 = Stone(Colors.Black, mockk())

        assertThat(stone.group).isNotEqualTo(stone2.group)
        stone.link(stone2)
        assertThat(stone.group).isEqualTo(stone2.group)
    }

    @Test
    fun `after linking stones that are already linked nothing changes`() {
        val stone = Stone(Colors.Black, mockk())
        val stone2 = Stone(Colors.Black, mockk())
        stone.link(stone2)
        val oldGroup = stone.group
        assertThat(stone.group).isEqualTo(stone2.group)
        stone.link(stone2)
        assertThat(stone.group).isEqualTo(oldGroup)
    }

    @Test
    fun `linking stones of different colors do nothing`() {
        val stone = Stone(Colors.Black, mockk())
        val stone2 = Stone(Colors.White, mockk())
        stone.link(stone2)
        assertThat(stone.group).isNotEqualTo(stone2.group)
    }

}
