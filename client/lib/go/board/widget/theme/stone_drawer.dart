import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/theme/go_colors.dart';

abstract class StoneDrawer {
  void draw(
    Canvas canvas,
    BoardCoordinates coordinatesManager,
    Position coordinate,
  );
}

class NoopDrawer extends StoneDrawer {
  @override
  void draw(
    Canvas canvas,
    BoardCoordinates coordinatesManager,
    Position coordinate,
  ) {}
}

class GeometryStoneDrawer extends StoneDrawer {
  late final Paint? _fill;
  late final Paint? _stroke;
  final double _stoneSizeRatio;

  GeometryStoneDrawer(
      {required double stoneSizeRatio, Color? fill, Color? stroke})
      : this._stoneSizeRatio = stoneSizeRatio {
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
    BoardCoordinates coordinatesManager,
    Position coordinate,
  ) {
    var center = coordinatesManager.fromCoordinate(coordinate);
    var size =
        min(coordinatesManager.cellWidth, coordinatesManager.cellHeight) *
            this._stoneSizeRatio;
    var rect = Rect.fromCenter(center: center, width: size, height: size);
    _drawCircleIfPaintNotNull(canvas, rect, _fill);
    _drawCircleIfPaintNotNull(canvas, rect, _stroke);
  }

  void _drawCircleIfPaintNotNull(Canvas canvas, Rect rect, Paint? paint) {
    if (paint != null) {
      var path = Path()..addOval(rect);
      canvas.drawPath(path, paint);
    }
  }
}

class StoneDrawers {
  static final StoneDrawer noop = NoopDrawer();

  late final Map<String, StoneDrawer> _dict;

  StoneDrawers(double stoneSizeRatio, {double opacity = 1.0}) {
    this._dict = {
      "white": GeometryStoneDrawer(
          stoneSizeRatio: stoneSizeRatio,
          fill: GoColors.WHITE.withOpacity(opacity),
          stroke: GoColors.GREY.withOpacity(opacity)),
      "black": GeometryStoneDrawer(
          stoneSizeRatio: stoneSizeRatio,
          fill: GoColors.BLACK.withOpacity(opacity))
    };
  }

  StoneDrawer forColor(String? color) {
    return _dict[color] ?? noop;
  }
}
