package org.ledoude.playgoserver.games

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

internal class `board intersection integration test` {
    @Test
    fun `placed stone appears in state`() {
        val board = Board(5, 5)
        val pos = Board.Position(2, 2)
        board.place(pos, Colors.White)
        val found = board.state().find { p -> p.position == pos }
        assertThat(found).isNotNull
        assertThat(found!!.position).isEqualTo(pos)
        assertThat(found.color).isEqualTo(Colors.White)
    }

    @Test
    fun `placing stones returns empty set if no captures`() {
        val board = Board(5, 5)
        val pos = Board.Position(2, 2)
        assertThat(board.place(pos, Colors.White)).isEmpty()
    }

    @Test
    fun `placing stones returns captured stones`() {
        val board = Board(5, 5)
        assertThat(board.place(Board.Position(2, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(1, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 2), Colors.Black)).isNotEmpty.hasSize(1)
            .allSatisfy { stone ->
                assertThat(stone.position).isEqualTo(Board.Position(2, 2))
                assertThat(stone.color).isEqualTo(Colors.White)
            }

        assertThat(board.state()).hasSize(4).allSatisfy { pair -> assertThat(pair.color).isEqualTo(Colors.Black) }
    }

    @Test
    fun `placing stones returns whole group of captured stones`() {
        val board = Board(5, 5)
        assertThat(board.place(Board.Position(2, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(3, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(1, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(4, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 3), Colors.Black)).isNotEmpty.hasSize(2)
            .allSatisfy { stone -> assertThat(stone.color).isEqualTo(Colors.White) }
        assertThat(board.state()).hasSize(6).allSatisfy { pair -> assertThat(pair.color).isEqualTo(Colors.Black) }
    }

    @Test
    fun `can't place in suffocating position (middle of ponuki)`() {
        val board = Board(5, 5)
        assertThat(board.place(Board.Position(1, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 2), Colors.Black)).isEmpty()

        assertThat(board.place(Board.Position(2, 2), Colors.White)).isEmpty()
        assertThat(board.state()).describedAs("The white stone is not placed as it is an invalid move")
            .hasSize(4)
            .allSatisfy { pair -> assertThat(pair.color).isEqualTo(Colors.Black) }
    }

    @Test
    fun `can't place in suffocating position (suffocate existing group)`() {
        val board = Board(5, 5)
        assertThat(board.place(Board.Position(1, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(4, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 3), Colors.Black)).isEmpty()

        assertThat(board.place(Board.Position(3, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(2, 2), Colors.White)).isEmpty()
        assertThat(board.state()).describedAs("The white stone is not placed as it is an invalid move")
            .hasSize(7).allSatisfy { pair -> assertThat(pair.color).isNotEqualTo(Board.Position(2, 2)) }
    }

    @Test
    fun `can place capturing even if suffocating (group captures single stone)`() {
        val board = Board(5, 5)

        assertThat(board.place(Board.Position(1, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(4, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 3), Colors.Black)).isEmpty()

        assertThat(board.place(Board.Position(1, 1), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(1, 3), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(0, 2), Colors.White)).isEmpty()

        assertThat(board.place(Board.Position(3, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(2, 2), Colors.White)).hasSize(1)
            .allSatisfy { stone ->
                assertThat(stone.position).isEqualTo(Board.Position(1, 2))
                assertThat(stone.color).isEqualTo(Colors.Black)
            }

        assertThat(board.state())
            .hasSize(10).allSatisfy { pair -> assertThat(pair.color).isNotEqualTo(Board.Position(1, 2)) }
    }

    @Test
    fun `can place capturing even if suffocating (single stone captures group)`() {
        val board = Board(5, 5)

        assertThat(board.place(Board.Position(2, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(2, 3), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 1), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(4, 2), Colors.Black)).isEmpty()
        assertThat(board.place(Board.Position(3, 3), Colors.Black)).isEmpty()

        assertThat(board.place(Board.Position(1, 1), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(1, 3), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(0, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(3, 2), Colors.White)).isEmpty()
        assertThat(board.place(Board.Position(2, 2), Colors.White)).isEmpty()

        assertThat(board.place(Board.Position(1, 2), Colors.Black)).hasSize(2)
            .allSatisfy { stone ->
                assertThat(stone.color).isEqualTo(Colors.White)
            }

        assertThat(board.state())
            .hasSize(9).allSatisfy { pair ->
                assertThat(pair.position).isNotEqualTo(Board.Position(2, 2))
                assertThat(pair.position).isNotEqualTo(Board.Position(3, 2))
            }
    }
}