import 'dart:ui';

import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/layers/board_layer.dart';

class StoneShadowsLayer extends BoardLayer {

  final Board _board;
  final BoardTheme _theme;

  StoneShadowsLayer(this._board, this._theme) : super(24);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    this._board.intersections.forEach((inter) {
      if (inter.present) {
        this._theme.stoneDrawers.shadows.draw(
            canvas, coordMngr, inter.coordinate);
      }
    });
  }

}