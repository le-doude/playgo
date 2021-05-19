import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class StonesDrawer extends BoardPaintable {
  final Layout layout;
  final BoardTheme theme;
  final Board board;
  List<int> previousRenderedImage = List.empty();

  StonesDrawer(this.layout, this.theme, this.board) : super(20);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    this.previousRenderedImage = this.board.image();
    this.board.intersections.forEach(
        (intersection) => renderIntersection(canvas, coordMngr, intersection));
  }

  void renderIntersection(Canvas canvas, BoardCoordinatesManager coordMngr,
      Intersection intersection) {
    theme.stoneDrawers
        .drawerForColor(intersection.maybeStone?.color)
        .draw(canvas, coordMngr, intersection.coordinate);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this.previousRenderedImage != this.board.image();
  }
}
