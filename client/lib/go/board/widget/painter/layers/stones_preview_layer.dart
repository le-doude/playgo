import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

import 'board_layer.dart';

class StonesPreviewLayer extends BoardLayer {
  final StonePreviewHolder holder;
  final BoardTheme theme;

  StonesPreviewLayer(this.holder, this.theme) : super(30);

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordMngr) {
    StonePreview? preview = this.holder.value;
    if (preview != null) {
      var drawer =
          this.theme.previewDrawers.forColor(preview.color);
      drawer.draw(canvas, coordMngr, preview.coordinate);
    }
  }
}
