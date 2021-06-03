package org.ledoude.playgoserver.games

class Board(val columns: Int, val rows: Int) {
    data class Position(val column: Int, val row: Int) {
        val surrounding: Set<Position> by lazy {
            arrayOf(
                Position(this.column + 1, this.row),
                Position(this.column - 1, this.row),
                Position(this.column, this.row + 1),
                Position(this.column, this.row - 1)
            ).toSet()
        }
    }

    data class Intersection(val position: Position, internal val board: Board) {
        var stone: Stone? = null
        val neighbours: Set<Intersection> by lazy {
            position.surrounding.mapNotNull { p -> this.board.get(p) }.toSet()
        }

        fun place(color: Colors): Set<Stone> {
            if (empty) {
                this.stone = Stone(color = color, intersection = this, number = this.board.incrementMoves())
                neighbours.forEach { i -> i.stone?.link(this.stone!!) }
                val captures =
                    neighbours.filter { i -> i.stone?.color != color && i.stone?.group?.freedoms()?.isEmpty() == true }
                        .toSet()
                return captures.mapNotNull { i -> i.clearGroup() }.flatten().toSet()
            } else return setOf()
        }

        private fun clearGroup(): Set<Stone>? {
            val stones = this.stone?.group?.stones
            stones?.forEach { s -> s.intersection.stone = null }
            return stones
        }

        fun canPlace(color: Colors): Boolean {
            if(this.present) return false
            for (n in neighbours) {
                if(n.empty) return true // new move has direct liberties
                if(n.stone!!.color != color) {
                    // would generate liberties by capturing adjacent groups of different colors
                    if(n.stone?.group?.freedoms()?.singleOrNull() == this.position) return true
                } else {
                    // neighbours of same color has liberties other than the current one
                    if(n.stone?.group?.freedoms()?.any { p -> p != this.position } == true) return true
                }
            }
            // else this intersection is not playable
            return false
        }

        val empty: Boolean
            get() {
                return this.stone == null
            }

        val present: Boolean
            get() {
                return !empty
            }
    }

    private var moveNumber: Int = 0
    private fun incrementMoves(): Int {
        this.moveNumber++
        return this.moveNumber
    }

    private val intersections: Array<Array<Intersection>> by lazy {
        Array(columns) { column -> Array(rows) { row -> Intersection(Position(column, row), this) } }
    }

    private fun get(position: Position): Intersection? {
        if (!withinBounds(position)) {
            return null
        }
        return this.intersections[position.column][position.row]
    }

    private fun withinBounds(position: Position): Boolean {
        return 0 <= position.column && position.column < this.columns &&
                0 <= position.row && position.row < this.rows
    }

    fun state(): List<Stone> {
        return this.intersections.flatten()
            .filter { intersection -> intersection.present }
            .mapNotNull { intersection -> intersection.stone }
    }

    fun place(position: Position, color: Colors): Set<Stone> {
        if (withinBounds(position)) {
            val intersection = get(position)
            if (intersection?.canPlace(color) == true) {
                return intersection.place(color)
            }
        }
        return setOf()
    }
}
