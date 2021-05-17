class Layout {
  final int columns;
  final int rows;
  final List<BoardCoordinate> startPoints;

  Layout(this.columns, this.rows, this.startPoints);
}

class Layouts {
  static final Layout STANDARD_19_BY_19 = Layout(19, 19, [
    BoardCoordinate(3, 3),
    BoardCoordinate(15, 3),
    BoardCoordinate(3, 15),
    BoardCoordinate(15, 15),
    BoardCoordinate(8, 8),
    BoardCoordinate(15, 8),
    BoardCoordinate(3, 8),
    BoardCoordinate(8, 15),
    BoardCoordinate(8, 3),
  ]);
  static final Layout STANDARD_13_BY_13 = Layout(13, 13, [
    BoardCoordinate(3, 3),
    BoardCoordinate(3, 9),
    BoardCoordinate(6, 6),
    BoardCoordinate(9, 3),
    BoardCoordinate(9, 9),
  ]);
  static final Layout STANDARD_9_BY_9 = Layout(9, 9, [
    BoardCoordinate(4, 4),
    BoardCoordinate(2, 2),
    BoardCoordinate(6, 6),
    BoardCoordinate(6, 2),
    BoardCoordinate(2, 6),
  ]);
}

class BoardCoordinate {
  final int column;
  final int row;

  BoardCoordinate(this.column, this.row);
}
