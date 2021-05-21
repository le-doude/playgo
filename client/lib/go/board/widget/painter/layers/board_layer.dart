import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

abstract class BoardLayer {
  final int priority;

  BoardLayer(this.priority);

  void draw(Canvas canvas, BoardCoordinatesManager coordMngr);
}
