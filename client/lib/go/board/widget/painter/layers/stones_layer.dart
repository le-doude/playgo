import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

import 'board_layer.dart';

class StonesLayer extends BoardLayer {
  static final Logger logger = Logger();
  final BoardTheme theme;
  final Board board;

  StonesLayer(this.board, this.theme) : super(20);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    this.board.intersections.forEach(
        (intersection) => renderIntersection(canvas, coordMngr, intersection));
  }

  void renderIntersection(Canvas canvas, BoardCoordinatesManager coordMngr,
      Intersection intersection) {
    theme.stoneDrawers
        .drawerForColor(intersection.stone?.color)
        .draw(canvas, coordMngr, intersection.coordinate);
  }
}
