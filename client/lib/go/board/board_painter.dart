import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_grid_drawer.dart';
import 'package:play_go_client/go/board/board_references_drawer.dart';
import 'package:play_go_client/go/board/board_startpoints_drawer.dart';
import 'package:play_go_client/go/board/stones_drawer.dart';
import 'package:play_go_client/go/board/stones_preview_painter.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';

class BoardPainter extends CustomPainter {
  static final Logger logger = Logger();
  final Board board;
  final BoardTheme theme;
  final List<BoardLayer> layers = List.empty(growable: true);

  BoardPainter(Listenable? repaint, this.board, this.theme,
      {List<BoardLayer>? layeredComponents})
      : super(repaint: repaint) {
    this.layers.add(BoardGridDrawer(this.board.layout, theme));
    this.layers.add(BoardStarPointsDrawer(this.board.layout, theme));
    this.layers.add(BoardReferencesDrawer(this.board.layout, theme));
    this.layers.add(StonesPainter(this.board, theme));
    this.layers.add(StonesPreviewPainter(this.board, theme, "white"));
    this.layers.addAll(layeredComponents ?? []);
    this.layers.sort((l, r) => l.priority.compareTo(r.priority));
  }

  @override
  void paint(Canvas canvas, Size size) {
    BoardCoordinatesManager coord = computeLayoutCoordinates(size);
    this.layers.forEach((component) {
      component.draw(canvas, coord);
    });
  }

  BoardCoordinatesManager computeLayoutCoordinates(Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var frameSize = min(size.height, size.width);
    var frameRect =
        Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    var gridSize = frameSize * 0.9;
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
