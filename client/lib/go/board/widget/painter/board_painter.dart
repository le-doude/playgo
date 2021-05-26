import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';

import 'board_coordinates_manager.dart';
import 'layers/board_layer.dart';
import 'layers/grid_drawer.dart';
import 'layers/references_layer.dart';
import 'layers/star_points_drawer.dart';

class BoardPainter extends CustomPainter {
  final Layout layout;
  final BoardTheme theme;
  final List<BoardLayer> layers = List.empty(growable: true);

  BoardCoordinatesManager? _coordinatesManager;
  BoardCoordinatesManager get coordinatesManager => _coordinatesManager!;

  BoardPainter(this.layout, this.theme, {List<BoardLayer>? extraComponents}) {
    this.layers.add(GridDrawer(this.layout, theme));
    this.layers.add(StarPointsDrawer(this.layout, theme));
    this.layers.add(ReferencesLayer(this.layout, theme));
    this.layers.addAll(extraComponents ?? []);
    this.layers.sort((l, r) => l.priority.compareTo(r.priority));
  }

  @override
  void paint(Canvas canvas, Size size) {
    this._coordinatesManager =
        BoardCoordinatesManager.compute(layout, theme, size);
    this.layers.forEach((component) {
      component.draw(canvas, this._coordinatesManager!);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


