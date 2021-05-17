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
    drawSomeStones(canvas, intersections);
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
    return BoardIntersections(frame: frame, layout: this.layout);
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
    var textSize = intersections.cellHeight / 2;
    for (int i = 0; i < this.layout.columns; i++) {
      var offset = intersections.get(i, 0);
      var top = frameRect.top * 0.75 + gridRect.top  * 0.25;
      var pOffset = Offset(offset.dx - textSize / 3, top);
      drawText(canvas, numberAtCoordinate(i), pOffset, textSize);
    }

    for (int i = 0; i < this.layout.rows; i++) {
      var offset = intersections.get(0, i);
      var left = frameRect.left * 0.75 + gridRect.left * 0.25;
      var pOffset = Offset(left, offset.dy - textSize / 2);
      drawText(canvas, numberAtCoordinate(i), pOffset, textSize);
    }
  }

  String numberAtCoordinate(int i) {
    return (i + 1).toString();
  }

  void drawText(Canvas canvas, String numberAtCoordinate, Offset pOffset,
      double size) {
    var painter = TextPainter(
        text: TextSpan(
            text: numberAtCoordinate,
            style: TextStyle(
                color: Colors.black, fontSize: size, fontFamily: "Futura")),
        maxLines: 1,
        textDirection: TextDirection.ltr
    );
    painter.layout();
    painter.paint(canvas, pOffset);
  }

  void drawSomeStones(Canvas canvas, BoardIntersections intersections) {
    var radius = intersections.cellHeight / 2.15;
    canvas.drawCircle(intersections.get(0, 0), radius, white());
    canvas.drawCircle(intersections.get(0, 1), radius, black());
    canvas.drawCircle(intersections.get(5, 0), radius, white());
    canvas.drawCircle(intersections.get(3, 3), radius, black());
    canvas.drawCircle(intersections.get(8, 8), radius, white());
  }

  Paint white() {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    return paint;
  }

  Paint black() {
    var paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    return paint;
  }
}

class BoardIntersections {
  Rect frame;
  Layout layout;
  List<List<Offset>> columns;
  List<List<Offset>> rows;
  double cellWidth;
  double cellHeight;

  BoardIntersections({Rect frame, Layout layout}) {
    this.frame = frame;
    this.layout = layout;
    this.cellWidth = frame.width / this.layout.columns;
    this.cellHeight = frame.height / this.layout.rows;
    var rect = Rect.fromCenter(
        center: frame.center,
        width: frame.width - this.cellWidth,
        height: frame.height - this.cellHeight);
    this.columns = List.generate(
        this.layout.columns,
            (i) =>
            List.generate(this.layout.rows,
                    (j) =>
                    Offset(rect.left + i * this.cellWidth,
                        rect.top + j * this.cellHeight)),
        growable: false);
    this.rows = List.generate(
        this.layout.rows,
            (j) =>
            List.generate(this.layout.columns,
                    (i) =>
                    Offset(rect.left + i * this.cellWidth,
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
}
