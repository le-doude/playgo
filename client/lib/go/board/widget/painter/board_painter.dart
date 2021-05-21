import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';
import 'layers/board_grid_drawer.dart';
import 'layers/board_references_drawer.dart';
import 'layers/board_startpoints_drawer.dart';
import 'layers/stones_drawer.dart';
import 'layers/stones_preview_painter.dart';

class BoardPainter extends CustomPainter {
  static final Logger logger = Logger();
  final Board board;
  final BoardTheme theme;
  final List<BoardLayer> layers = List.empty(growable: true);
  late final StonesPreviewPainter _previewLayer;
  BoardCoordinatesManager? _coordinatesManager;

  BoardCoordinatesManager get coordinatesManager => _coordinatesManager!;

  BoardPainter(this.board, this.theme, {List<BoardLayer>? layeredComponents})
      : super(repaint: board) {
    this.layers.add(BoardGridDrawer(this.board.layout, theme));
    this.layers.add(BoardStarPointsDrawer(this.board.layout, theme));
    this.layers.add(BoardReferencesDrawer(this.board.layout, theme));
    this.layers.add(StonesPainter(this.board, theme));
    this._previewLayer = StonesPreviewPainter(this.board, theme);
    this.layers.add(_previewLayer);
    this.layers.addAll(layeredComponents ?? []);
    this.layers.sort((l, r) => l.priority.compareTo(r.priority));
  }

  @override
  void paint(Canvas canvas, Size size) {
    this._coordinatesManager = _computeLayoutCoordinates(size);
    this.layers.forEach((component) {
      component.draw(canvas, this._coordinatesManager!);
    });
  }

  BoardCoordinatesManager _computeLayoutCoordinates(Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var frameSize = min(size.height, size.width);
    var frameRect =
        Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    var gridSize = frameSize * (this.theme.drawReferences ? 0.9 : 1.0);
    var gridRect =
        Rect.fromCenter(center: center, width: gridSize, height: gridSize);
    BoardCoordinatesManager coord = BoardCoordinatesManager(
        outerFrame: frameRect, innerFrame: gridRect, layout: this.board.layout);
    return coord;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

abstract class BoardLayer {
  final int priority;

  BoardLayer(this.priority);

  void draw(Canvas canvas, BoardCoordinatesManager coordMngr);
}
