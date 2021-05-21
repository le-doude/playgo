import 'dart:math';

import 'package:play_go_client/go/board.dart';

class Layout {
  final int columns;
  final int rows;
  final List<BoardCoordinate> startPoints;

  Layout(this.columns, this.rows, this.startPoints);

  List<List<T>> generateTable<T>(
      T Function(int column, int row) cellGen) {
    return List.generate(
        this.columns,
        (column) => List.generate(
            this.rows, (row) => cellGen.call(column, row)));
  }

  Set<BoardCoordinate> computeNeighbours(BoardCoordinate coordinate) {
    return [
      coordinate.translate(0, 1),
      coordinate.translate(1, 0),
      coordinate.translate(-1, 0),
      coordinate.translate(0, -1),
    ].where((e) => this.includes(e)).toSet();
  }

  bool includes(BoardCoordinate coordinate) {
    return 0 <= coordinate.column &&
        coordinate.column < this.columns &&
        0 <= coordinate.row &&
        coordinate.row < this.rows;
  }
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
      other is BoardCoordinate &&
          column == other.column &&
          row == other.row;

  @override
  int get hashCode => column.hashCode ^ row.hashCode;

  BoardCoordinate translate(int xIncr, int yIncr) {
    var x = column + xIncr;
    var y = row + yIncr;
    return BoardCoordinate(x, y);
  }
}

class InvalidCoordinatesError {}
