import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

abstract class StoneDrawer {
  void draw(
    Canvas canvas,
    BoardCoordinatesManager coordinatesManager,
    BoardCoordinate coordinate,
  );
}

class NoopDrawer extends StoneDrawer {
  @override
  void draw(
    Canvas canvas,
    BoardCoordinatesManager coordinatesManager,
    BoardCoordinate coordinate,
  ) {}
}

class GeometryStoneDrawer extends StoneDrawer {
  final Paint? fill;
  final Paint? stroke;

  GeometryStoneDrawer({this.fill, this.stroke});

  @override
  void draw(
    Canvas canvas,
    BoardCoordinatesManager coordinatesManager,
    BoardCoordinate coordinate,
  ) {
    var center = coordinatesManager.fromCoordinate(coordinate);
    var radius = coordinatesManager.cellHeight * 0.465;
    _drawCircleIfPaintNotNull(canvas, center, radius, fill);
    _drawCircleIfPaintNotNull(canvas, center, radius, stroke);
  }

  void _drawCircleIfPaintNotNull(
      Canvas canvas, Offset center, double radius, Paint? paint) {
    if (paint != null) {
      canvas.drawCircle(center, radius, paint!);
    }
  }
}

class StoneDrawers {}

class GoStonesColors {
  static final Color BLACK = Color.fromARGB(255, 27, 27, 20);
  static final Color WHITE = Color.fromARGB(255, 252, 252, 242);
}
