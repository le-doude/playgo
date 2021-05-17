import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'layout.dart';

class BoardGrid extends CustomPainter {
  final Layout layout;

  BoardGrid(this.layout);

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var frameSize = min(size.height, size.width);
    var gridSize = frameSize * 0.9;
    var gridRect =
        Rect.fromCenter(center: center, width: gridSize, height: gridSize);
    BoardIntersections intersections = calculateAllCenters(gridRect);
    drawGridFrom(canvas, intersections);
    drawStarPoints(canvas, intersections);
    var frameRect =
        Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    drawGridReference(canvas, intersections, frameRect, gridRect);
  }

  Paint gridInkPaint() {
    var blackPaint = Paint();
    blackPaint.style = PaintingStyle.fill;
    blackPaint.color = Colors.black.withOpacity(0.7);
    blackPaint.strokeWidth = 2.1;
    blackPaint.strokeCap = StrokeCap.square;
    blackPaint.isAntiAlias = true;
    return blackPaint;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void drawCoordText(Canvas canvas, Rect gridRect) {
    builder();
  }

  ParagraphBuilder builder() {
    return ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      fontFamily: "Arial",
      fontSize: 10,
      height: 10,
    ));
  }

  void drawCoordinateRefs(Canvas canvas, Rect frameRect) {}

  BoardIntersections calculateAllCenters(Rect frame) {
    var dx = frame.width / this.layout.columns;
    var dy = frame.height / this.layout.rows;
    var rect = Rect.fromCenter(
        center: frame.center,
        width: frame.width - dx,
        height: frame.height - dy);
    var centersColumnsFirst = List.generate(
        this.layout.columns,
        (i) => List.generate(this.layout.rows,
            (j) => Offset(rect.left + i * dx, rect.top + j * dy)),
        growable: false);
    var centersRowsFirst = List.generate(
        this.layout.rows,
        (j) => List.generate(this.layout.columns,
            (i) => Offset(rect.left + i * dx, rect.top + j * dy)),
        growable: false);
    return BoardIntersections(centersColumnsFirst, centersRowsFirst, dy, dx);
  }

  void drawGridFrom(Canvas canvas, BoardIntersections centers) {
    centers.columns.forEach((column) {
      canvas.drawLine(column.first, column.last, gridInkPaint());
    });
    centers.rows.forEach((row) {
      canvas.drawLine(row.first, row.last, gridInkPaint());
    });
  }

  void drawStarPoints(Canvas canvas, BoardIntersections intersections) {
    this.layout.startPoints.forEach((coordinate) {
      canvas.drawCircle(intersections.get(coordinate.column, coordinate.row), 5,
          gridInkPaint());
    });
  }

  void drawGridReference(Canvas canvas, BoardIntersections intersections,
      Rect frameRect, Rect gridRect) {
    var textSize = intersections.cellHeight / 4.5;
    for (int i = 0; i < this.layout.columns; i++) {
      var offset = intersections.get(i, 0);
      var top = (frameRect.top + gridRect.top) / 2;
      var pOffset = Offset(offset.dx - textSize / 3, top);
      drawText(canvas, numberAtCoordinate(i), pOffset, textSize);
    }

    for (int i = 0; i < this.layout.rows; i++) {
      var offset = intersections.get(0, i);
      var left = (frameRect.left + gridRect.left) / 2;
      var pOffset = Offset(left, offset.dy - textSize / 2);
      drawText(canvas, numberAtCoordinate(i), pOffset, textSize);
    }
  }

  String numberAtCoordinate(int i) {
    return (i + 1).toString();
  }

  void drawText(
      Canvas canvas, String numberAtCoordinate, Offset pOffset, double size) {
    var painter = TextPainter(
        text: TextSpan(
            text: numberAtCoordinate,
            style: TextStyle(color: Colors.black, fontSize: size, fontFamily: "Futura")),
        maxLines: 1,
        textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, pOffset);
  }
}

class BoardIntersections {
  final double cellHeight;
  final double cellWidth;
  final List<List<Offset>> columns;
  final List<List<Offset>> rows;

  BoardIntersections(this.columns, this.rows, this.cellHeight, this.cellWidth);

  Offset get(int x, int y) {
    return this.columns[x][y];
  }

  List<Offset> column(int column) {
    return this.columns[column];
  }

  List<Offset> row(int row) {
    return this.rows[row];
  }
}
