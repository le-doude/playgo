import 'dart:math';

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
    BoardCoordinate(9, 9),
    BoardCoordinate(15, 9),
    BoardCoordinate(3, 9),
    BoardCoordinate(9, 15),
    BoardCoordinate(9, 3),
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
  late final int column;
  late final int row;

  BoardCoordinate(int column, int row) {
    this.column = column;
    this.row = row;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardCoordinate &&
          runtimeType == other.runtimeType &&
          column == other.column &&
          row == other.row;

  @override
  int get hashCode => column.hashCode ^ row.hashCode;

  BoardCoordinate? up() {
    return fromCurrent(0, -1);
  }

  BoardCoordinate? down() {
    return fromCurrent(0, 1);
  }

  BoardCoordinate? left() {
    return fromCurrent(-1, 0);
  }

  BoardCoordinate? right() {
    return fromCurrent(1, 0);
  }

  BoardCoordinate? fromCurrent(int xIncr, int yIncr) {
    var x = column + xIncr;
    var y = row + yIncr;
    return BoardCoordinate(x, y);
  }
}

class InvalidCoordinatesError {}
