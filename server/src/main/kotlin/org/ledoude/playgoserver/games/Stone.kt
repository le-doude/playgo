package org.ledoude.playgoserver.games

data class Stone(
    val color: Colors,
    internal val intersection: Board.Intersection,
    val number: Int = -1,
) {
    var group: Group = Group(stones = setOf(this))

    val position: Board.Position
        get() = intersection.position

    fun link(other: Stone) {
        if (this.color == other.color) {
            Group.merge(this.group, other.group);
        }
    }

    data class Group(val stones: Set<Stone>) {
        fun freedoms(): Set<Board.Position> {
            return this.stones.flatMap { s -> s.intersection.neighbours }
                .filter { intersection -> intersection.empty() }
                .map { intersection -> intersection.position }
                .toSet()
        }

        companion object {
            fun merge(left: Group, right: Group): Group {
                if (left == right) {
                    return left
                }
                val stones: Set<Stone> = setOf(*left.stones.toTypedArray(), *right.stones.toTypedArray())
                val group = Group(stones = stones)
                stones.forEach { stone -> stone.group = group };
                return group
            }
        }
    }
}