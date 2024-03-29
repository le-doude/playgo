import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/layers/board_layer.dart';

class StoneShadowsLayer extends BoardLayer {
  final BoardNotifier _board;
  final BoardTheme _theme;

  StoneShadowsLayer(this._board, this._theme) : super(24);

  @override
  void draw(Canvas canvas, BoardCoordinates coordMngr) {
    canvas.save();
    var tx = coordMngr.cellWidth * this._theme.stoneShadowsOffsetRatio;
    var ty = coordMngr.cellHeight * this._theme.stoneShadowsOffsetRatio;
    canvas.translate(tx, ty);

    this._board.value.forEach((s) {
      double size = math.min(coordMngr.cellWidth, coordMngr.cellHeight) *
          this._theme.stoneSizeRatio;
      var stoneRect = Rect.fromCenter(
          center: coordMngr.fromCoordinate(s.position),
          width: size,
          height: size);
      var p = Path()..addOval(stoneRect);

      canvas.drawShadow(p, Colors.black, 1.5, true);
    });
    canvas.restore();
  }
}
