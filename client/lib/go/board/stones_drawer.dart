import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class StonesPainter extends BoardLayer {
  static final Logger logger = Logger();
  final BoardTheme theme;
  final Board board;
  List<int> previousRenderedImage = List.empty();

  StonesPainter(this.board, this.theme) : super(20);

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
}
