import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/board_grid_drawer.dart';
import 'package:play_go_client/go/board/board_references_drawer.dart';
import 'package:play_go_client/go/board/board_startpoints_drawer.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_coordinates_manager.dart';
import 'layout.dart';

class BoardPainter extends CustomPainter {
  static const List<BoardPaintable> EMPTY = [];
  final Layout layout;
  final BoardTheme theme;
  final List<BoardPaintable> components = List.empty(growable: true);

  BoardPainter(this.layout, this.theme,
      {List<BoardPaintable> layeredComponents = EMPTY}) {
    this.components.add(BoardGridDrawer(layout, theme));
    this.components.add(BoardStarPointsDrawer(layout, theme));
    this.components.add(BoardReferencesDrawer(layout, theme));
    this.components.addAll(layeredComponents);
    this.components.sort((l, r) => l.priority.compareTo(r.priority));
  }

  @override
  void paint(Canvas canvas, Size size) {
    BoardCoordinatesManager coord = computeLayoutCoordinates(size);
    this.components.forEach((element) {
      element.draw(canvas, coord);
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
        outerFrame: frameRect, innerFrame: gridRect, layout: this.layout);
    return coord;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this.components.any(
        (BoardPaintable component) => component.shouldRepaint(oldDelegate));
  }
}

abstract class BoardPaintable {
  final int priority;

  BoardPaintable(this.priority);

  void draw(Canvas canvas, BoardCoordinatesManager coordMngr);

  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}