import 'dart:ui';

import 'package:play_go_client/go/board/board_painter.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardGridDrawer extends BoardLayer{
  final Layout layout;
  final BoardTheme theme;

  BoardGridDrawer(this.layout, this.theme) : super(0);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    var paint = this.theme.inkLinesPaint();
    coordMngr.columnEdgeVertices().forEach((column) {
      canvas.drawLine(column.first, column.last, paint);
    });
    coordMngr.rowEdgeVertices().forEach((row) {
      canvas.drawLine(row.first, row.last, paint);
    });
  }
}
