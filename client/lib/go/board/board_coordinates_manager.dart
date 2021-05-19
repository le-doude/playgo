import 'dart:math';
import 'dart:ui';

import 'layout.dart';

class BoardCoordinatesManager {
  late final Rect outerFrame;
  late final Rect innerFrame;
  late final Layout layout;
  late final List<List<Offset>> columns;
  late final List<List<Offset>> rows;
  late final double cellWidth;
  late final double cellHeight;

  BoardCoordinatesManager(
      {required Rect outerFrame,
      required Rect innerFrame,
      required Layout layout}) {
    this.outerFrame = outerFrame;
    this.innerFrame = innerFrame;
    this.layout = layout;
    this.cellWidth = innerFrame.width / this.layout.columns;
    this.cellHeight = innerFrame.height / this.layout.rows;
    var rect = Rect.fromCenter(
        center: innerFrame.center,
        width: innerFrame.width - this.cellWidth,
        height: innerFrame.height - this.cellHeight);
    this.columns = List.generate(
        this.layout.columns,
        (i) => List.generate(
            this.layout.rows,
            (j) => Offset(rect.left + i * this.cellWidth,
                rect.top + j * this.cellHeight)),
        growable: false);
    this.rows = List.generate(
        this.layout.rows,
        (j) => List.generate(
            this.layout.columns,
            (i) => Offset(rect.left + i * this.cellWidth,
                rect.top + j * this.cellHeight)),
        growable: false);
  }

  Offset get(int x, int y) {
    return this.columns[x][y];
  }

  Offset fromCoordinate(BoardCoordinate coord) {
    return get(coord.column, coord.row);
  }

  List<Offset> column(int column) {
    return this.columns[column];
  }

  List<Offset> row(int row) {
    return this.rows[row];
  }

  BoardCoordinate from(Offset eventCoord) {
    if (!innerFrame.contains(eventCoord)) {
      throw OutOfBoardOffsetError();
    }
    int i = eventCoord.dx ~/ cellWidth;
    int j = eventCoord.dy ~/ cellHeight;
    return BoardCoordinate(i, j);
  }
}

class OutOfBoardOffsetError {
}
