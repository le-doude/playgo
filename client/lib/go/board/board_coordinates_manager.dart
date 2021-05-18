import 'dart:math';
import 'dart:ui';

import 'layout.dart';

class BoardCoordinatesManager {
  Rect outerFrame;
  Rect innerFrame;
  Layout layout;
  List<List<Offset>> columns;
  List<List<Offset>> rows;
  double cellWidth;
  double cellHeight;

  BoardCoordinatesManager({Rect outerFrame, Rect innerFrame, Layout layout}) {
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

  List<Offset> column(int column) {
    return this.columns[column];
  }

  List<Offset> row(int row) {
    return this.rows[row];
  }

  BoardCoordinate from(Offset eventCoord) {
    if (!innerFrame.contains(eventCoord)) {
      return null;
    }
    int i = eventCoord.dx ~/ cellWidth;
    int j = eventCoord.dy ~/ cellHeight;
    return BoardCoordinate(i, j);
  }
}
