import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/board_grid_drawer.dart';
import 'package:play_go_client/go/board/board_references_drawer.dart';
import 'package:play_go_client/go/board/board_startpoints_drawer.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';
import 'layout.dart';

class BoardPainter extends CustomPainter {
  final Layout layout;
  final BoardTheme theme;
  BoardGridDrawer boardGridDrawer;
  BoardStarPointsDrawer boardStarPointsDrawer;
  BoardReferencesDrawer boardReferencesDrawer;

  BoardPainter(this.layout, this.theme) {
    this.boardGridDrawer = BoardGridDrawer(layout, theme);
    this.boardStarPointsDrawer = BoardStarPointsDrawer(layout, theme);
    this.boardReferencesDrawer = BoardReferencesDrawer(layout, theme);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var frameSize = min(size.height, size.width);
    var frameRect =
        Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    var gridSize = frameSize * 0.9;
    var gridRect =
        Rect.fromCenter(center: center, width: gridSize, height: gridSize);
    BoardCoordinatesManager intersections = calculateAllCenters(frameRect, gridRect);
    this.boardGridDrawer.drawOn(canvas, intersections);
    this.boardStarPointsDrawer.drawOn(canvas, intersections);
    this.boardReferencesDrawer.drawOn(canvas, intersections);
    drawSomeStones(canvas, intersections);
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

  BoardCoordinatesManager calculateAllCenters(Rect outer, Rect inner) {
    return BoardCoordinatesManager(
        outerFrame: outer, innerFrame: inner, layout: this.layout);
  }

  void drawGridReference(Canvas canvas, BoardCoordinatesManager intersections,
      Rect outerFrame, Rect innerFrame) {
    this.boardReferencesDrawer.drawOn(canvas, intersections);
  }

  void drawSomeStones(Canvas canvas, BoardCoordinatesManager intersections) {
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
