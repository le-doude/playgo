import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/widget/painter/layers/stones_shadows_layer.dart';

import 'board_coordinates_manager.dart';
import 'layers/board_layer.dart';
import 'layers/stones_layer.dart';
import 'layers/stones_preview_layer.dart';

class StonesPainter extends CustomPainter {
  static final Logger logger = Logger();
  final BoardNotifier board;
  late final StonePreviewHolder? previewHolder;
  final BoardTheme theme;
  final Layout layout;
  final List<BoardLayer> layers = List.empty(growable: true);

  BoardCoordinates? _coordinatesManager;

  BoardCoordinates get coordinatesManager => _coordinatesManager!;

  StonesPainter(this.board, this.theme, this.layout,
      {List<BoardLayer>? layeredComponents, StonePreviewHolder? previewHolder})
      : super(repaint: Listenable.merge([board, previewHolder])) {
    this.layers.add(StonesLayer(board, theme));
    if (previewHolder != null) {
      this.layers.add(StonesPreviewLayer(previewHolder, theme));
    }
    this.layers.add(StoneShadowsLayer(board, this.theme));
    this.layers.addAll(layeredComponents ?? []);
    this.layers.sort((l, r) => l.priority.compareTo(r.priority));
  }

  @override
  void paint(Canvas canvas, Size size) {
    this._coordinatesManager =
        BoardCoordinates.compute(this.layout, theme, size);
    this.layers.forEach((component) {
      component.draw(canvas, this._coordinatesManager!);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
