

class Layout {
  final int columns;
  final int rows;
  final List<Position> startPoints;

  Layout(this.columns, this.rows, this.startPoints);

  List<List<T>> generateTable<T>(
      T Function(int column, int row) cellGen) {
    return List.generate(
        this.columns,
        (column) => List.generate(
            this.rows, (row) => cellGen.call(column, row)));
  }

  Set<Position> computeNeighbours(Position coordinate) {
    return [
      coordinate.translate(0, 1),
      coordinate.translate(1, 0),
      coordinate.translate(-1, 0),
      coordinate.translate(0, -1),
    ].where((e) => this.includes(e)).toSet();
  }

  bool includes(Position coordinate) {
    return 0 <= coordinate.column &&
        coordinate.column < this.columns &&
        0 <= coordinate.row &&
        coordinate.row < this.rows;
  }
}

class Layouts {
  static final Layout STANDARD_19_BY_19 = Layout(19, 19, [
    Position(3, 3),
    Position(15, 3),
    Position(3, 15),
    Position(15, 15),
    Position(9, 9),
    Position(15, 9),
    Position(3, 9),
    Position(9, 15),
    Position(9, 3),
  ]);
  static final Layout STANDARD_13_BY_13 = Layout(13, 13, [
    Position(3, 3),
    Position(3, 9),
    Position(6, 6),
    Position(9, 3),
    Position(9, 9),
  ]);
  static final Layout STANDARD_9_BY_9 = Layout(9, 9, [
    Position(4, 4),
    Position(2, 2),
    Position(6, 6),
    Position(6, 2),
    Position(2, 6),
  ]);
}

class Position {
  late final int column;
  late final int row;

  Position(int column, int row) {
    this.column = column;
    this.row = row;
  }

  @override
  bool operator ==(Object other) =>
      other is Position &&
          column == other.column &&
          row == other.row;

  @override
  int get hashCode => column.hashCode ^ row.hashCode;

  Position translate(int xIncr, int yIncr) {
    var x = column + xIncr;
    var y = row + yIncr;
    return Position(x, y);
  }
}

class InvalidCoordinatesError {}
