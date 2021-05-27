import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

import 'board_layer.dart';

class StonesLayer extends BoardLayer {
  static final Logger logger = Logger();
  final BoardTheme theme;
  final BoardNotifier board;

  StonesLayer(this.board, this.theme) : super(25);

  @override
  void draw(Canvas canvas, BoardCoordinates coordMngr) {
    this.board.value.forEach(
        (s) => renderIntersection(canvas, coordMngr, s));
  }

  void renderIntersection(Canvas canvas, BoardCoordinates coordMngr,
      StonePosition sp) {
    theme.stoneDrawers
        .forColor(sp.color)
        .draw(canvas, coordMngr, sp.position);
  }
}
