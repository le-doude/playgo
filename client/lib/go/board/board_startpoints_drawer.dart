import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardStarPointsDrawer {
  final Layout layout;
  final BoardTheme theme;

  BoardStarPointsDrawer(this.layout, this.theme);

  void drawOn(Canvas canvas, BoardCoordinatesManager intersections) {
    var paint = this.theme.inkLinesPaint();
    var radius = this.theme.startPointSize();
    this.layout.startPoints.forEach((point) {
      canvas.drawCircle(intersections.get(point.column, point.row), radius, paint);
    });
  }
}
