import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'layout.dart';

class BoardCoordinatesManager {
  static final Logger logger = Logger();

  late final Rect outerFrame;
  late final Rect innerFrame;
  late final Rect gridFrame;
  late final Layout layout;
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
    this.gridFrame = Rect.fromCenter(
        center: innerFrame.center,
        width: innerFrame.width - this.cellWidth,
        height: innerFrame.height - this.cellHeight);
  }

  Offset get(int i, int j) {
    return Offset(gridFrame.left + i * this.cellWidth,
        gridFrame.top + j * this.cellHeight);
  }

  Offset fromCoordinate(BoardCoordinate coord) {
    return get(coord.column, coord.row);
  }

  List<Offset> column(int column) {
    return [get(column, 0), get(column, this.layout.rows - 1)];
  }

  List<Offset> row(int row) {
    return [get(0, row), get(this.layout.columns - 1, row)];
  }

  bool isInFrame(Offset coord) {
    return innerFrame.contains(coord);
  }

  BoardCoordinate from(Offset eventCoord) {
    if (!isInFrame(eventCoord)) {
      throw OutOfBoardOffsetError();
    }
    return BoardCoordinate((eventCoord.dx - this.innerFrame.left) ~/ cellWidth,
        (eventCoord.dy - this.innerFrame.top) ~/ cellHeight);
  }

  List<List<Offset>> rowEdgeVertices() {
    List<List<Offset>> list = [];
    for (int i = 0; i < this.layout.rows; i++) {
      list.add(row(i));
    }
    return list;
  }

  List<List<Offset>> columnEdgeVertices() {
    List<List<Offset>> list = [];
    for (int i = 0; i < this.layout.columns; i++) {
      list.add(column(i));
    }
    return list;
  }
}

class OutOfBoardOffsetError {}
