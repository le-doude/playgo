import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/board_painter.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

class StonesPreviewPainter extends BoardPaintable {
  final Layout layout;
  final BoardTheme theme;
  final Board board;
  final String color;
  bool _hasChanged = false;
  BoardCoordinate? _current;

  void preview(BoardCoordinate coord) {
    if (this.board.canPlace(Stone(color: color), coord)) {
      this._hasChanged = this._current != coord;
      this._current = coord;
    }
  }

  StonesPreviewPainter(this.layout, this.theme, this.board, this.color)
      : super(25);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    this._hasChanged = false;
    if (_current != null) {
      var drawer = this.theme.stoneDrawers.drawerForColor(this.color);
      drawer.draw(canvas, coordMngr, _current!, preview: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => _hasChanged;
}
