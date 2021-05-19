import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board/board_painter.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardStarPointsDrawer extends BoardLayer{
  final Layout layout;
  final BoardTheme theme;

  BoardStarPointsDrawer(this.layout, this.theme) : super(1);

  void draw(Canvas canvas, BoardCoordinatesManager intersections) {
    var paint = this.theme.inkLinesPaint();
    var radius = this.theme.startPointSize();
    this.layout.startPoints.forEach((point) {
      canvas.drawCircle(intersections.get(point.column, point.row), radius, paint);
    });
  }
}
