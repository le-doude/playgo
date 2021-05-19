import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/board_painter.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

class StonesPreviewPainter extends BoardLayer {
  final Board board;
  final BoardTheme theme;
  final String color;
  BoardCoordinate? _current;

  void preview(BoardCoordinate coord) {
    if (this.board.canPlace(Stone(color: color), coord)) {
      this._current = coord;
    }
  }

  StonesPreviewPainter(this.board, this.theme,  this.color)
      : super(25);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    if (_current != null) {
      var drawer = this.theme.stoneDrawers.drawerForColor(this.color);
      drawer.draw(canvas, coordMngr, _current!, preview: true);
    }
  }
}
