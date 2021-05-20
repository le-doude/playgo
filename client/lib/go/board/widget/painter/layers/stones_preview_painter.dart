import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_painter.dart';

class StonesPreviewPainter extends BoardLayer {
  final Board board;
  final BoardTheme theme;
  Stone? _stone;
  BoardCoordinate? _current;

  void preview(Stone stone, BoardCoordinate coord) {
    if (this.board.canPlace(stone, coord)) {
      this._stone = stone;
      this._current = coord;
    }
  }

  StonesPreviewPainter(this.board, this.theme) : super(25);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    if (_current != null && _stone != null) {
      var drawer = this.theme.stoneDrawers.drawerForColor(this._stone!.color);
      drawer.draw(canvas, coordMngr, _current!, preview: true);
    }
  }

  void clear() {
    this._stone = null;
    this._current = null;
  }
}
