import 'dart:ui';

import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/layers/board_layer.dart';

class StoneShadowsLayer extends BoardLayer {
  final BoardState _board;
  final BoardTheme _theme;

  StoneShadowsLayer(this._board, this._theme) : super(24);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    canvas.save();
    var tx = coordMngr.cellWidth * 0.075;
    var ty = coordMngr.cellHeight * 0.075;
    canvas.translate(tx, ty);
    this._board.state.forEach((s) {
      this._theme.stoneDrawers.shadows.draw(canvas, coordMngr, s.position);
    });
    canvas.restore();
  }
}
