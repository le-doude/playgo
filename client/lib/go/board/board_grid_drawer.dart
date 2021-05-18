import 'dart:ui';

import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardGridDrawer {
  final Layout layout;
  final BoardTheme theme;

  BoardGridDrawer(this.layout, this.theme);

  void drawOn(Canvas canvas, BoardCoordinatesManager intersections) {
    var paint = this.theme.inkLinesPaint();
    intersections.columns.forEach((column) {
      canvas.drawLine(column.first, column.last, paint);
    });
    intersections.rows.forEach((row) {
      canvas.drawLine(row.first, row.last, paint);
    });
  }
}
