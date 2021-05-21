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
  late final Paint? _fill;
  late final Paint? _stroke;

  GeometryStoneDrawer({Color? fill, Color? stroke}) {
    this._fill = paint(fill, PaintingStyle.fill);
    this._stroke = paint(stroke, PaintingStyle.stroke);
  }

  static Paint? paint(Color? color, PaintingStyle style) {
    if (color == null) return null;
    return Paint()
      ..color = color
      ..style = style
      ..strokeWidth = 1
      ..isAntiAlias = true;
  }

  @override
  void draw(
    Canvas canvas,
    BoardCoordinatesManager coordinatesManager,
    BoardCoordinate coordinate,
  ) {
    var center = coordinatesManager.fromCoordinate(coordinate);
    var radius = coordinatesManager.cellHeight * 0.465;
    _drawCircleIfPaintNotNull(canvas, center, radius, _fill);
    _drawCircleIfPaintNotNull(canvas, center, radius, _stroke);
  }

  void _drawCircleIfPaintNotNull(
      Canvas canvas, Offset center, double radius, Paint? paint) {
    if (paint != null) {
      canvas.drawCircle(center, radius, paint);
    }
  }
}

class StoneDrawers {
  static final StoneDrawer white = GeometryStoneDrawer(
      fill: GoStonesColors.WHITE, stroke: GoStonesColors.GREY);
  static final StoneDrawer black =
      GeometryStoneDrawer(fill: GoStonesColors.BLACK);
  static final StoneDrawer shadowDrawer =
      GeometryStoneDrawer(fill: GoStonesColors.BLACK.withOpacity(0.25));

  static final StoneDrawer whitePreview = GeometryStoneDrawer(
    fill: GoStonesColors.WHITE.withOpacity(0.8),
  );
  static final StoneDrawer blackPreview =
      GeometryStoneDrawer(fill: GoStonesColors.BLACK.withOpacity(0.8));

  static final StoneDrawer noop = NoopDrawer();

  StoneDrawer forColor(String? color, {bool preview = false}) {
    if (color == "white") {
      return preview ? whitePreview : white;
    }
    if (color == "black") {
      return preview ? blackPreview : black;
    }
    return noop;
  }

  StoneDrawer get shadows => StoneDrawers.shadowDrawer;
}

class GoStonesColors {
  static final Color BLACK = Color.fromARGB(255, 27, 27, 20);
  static final Color WHITE = Color.fromARGB(255, 252, 252, 242);
  static final Color GREY = Colors.blueGrey;
}
