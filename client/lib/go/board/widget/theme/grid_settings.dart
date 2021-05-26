import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/widget/theme/go_colors.dart';

abstract class GridSettings {
  Paint inkPaint();
  double starPointSize(double cellSize);
}

class BaseGridSettings extends GridSettings {
  final Color inkColor;
  final double starPointToCellSizeRatio;
  final double lineWidth;

  BaseGridSettings(
      {Color? inkColor,
      double starPointToCellSizeRatio = 0.09,
      double lineWidth = 1})
      : inkColor = inkColor ?? GoColors.DARKEST_INK,
        starPointToCellSizeRatio = starPointToCellSizeRatio,
        lineWidth = lineWidth;

  Paint inkPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = inkColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;
  }

  double starPointSize(double cellSize) {
    return starPointToCellSizeRatio * cellSize;
  }
}
