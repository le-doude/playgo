import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board/board_painter.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardReferencesDrawer extends BoardPaintable{
  static final Logger logger = Logger();

  final Layout layout;
  final BoardTheme theme;

  BoardReferencesDrawer(this.layout, this.theme) : super(2);

  void draw(Canvas canvas, BoardCoordinatesManager intersections) {
    var top = intersections.outerFrame.top +
        intersections.innerFrame.top ;
    top /= 2;
    var left = intersections.outerFrame.left +
        intersections.innerFrame.left;
    left /= 2;

    for (int i = 0; i < this.layout.columns; i++) {
      var offset = intersections.get(i, 0);
      var pOffset = Offset(offset.dx, top);
      drawText(canvas, this.theme.verticalReferencesType().toText(i + 1),
          pOffset, intersections.cellHeight);
    }
    for (int i = 0; i < this.layout.rows; i++) {
      var offset = intersections.get(0, i);
      var pOffset = Offset(left, offset.dy);
      drawText(canvas, this.theme.horizontalReferencesType().toText(i + 1),
          pOffset, intersections.cellHeight);
    }
  }

  void drawText(
      Canvas canvas, String reference, Offset textCenter, double cellSize) {
    var painter = TextPainter(
        text: TextSpan(
            text: reference, style: this.theme.boardRefernceStyle(cellSize)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
    );
    painter.layout();
    var metrics = painter.computeLineMetrics().first;
    var textRect = Rect.fromCenter(
        center: textCenter, width: metrics.width, height: metrics.height);
    painter.paint(canvas, textRect.topLeft);
  }
}
