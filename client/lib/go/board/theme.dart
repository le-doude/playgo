import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/layout.dart';

class BoardTheme {
  static const Color BLACK_ISH = Color.fromARGB(255, 30, 30, 15);

  final BoardRefType refType = BoardRefType();
  final Paint inkLinesStyle = Paint()
    ..style = PaintingStyle.fill
    ..color = BLACK_ISH
    ..strokeWidth = 2.1
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true;
  final StoneDrawers stoneDrawers = StoneDrawers();

  double get aspectRatio => 42/43;

  bool get drawReferences => true;

  Paint inkLinesPaint() {
    return this.inkLinesStyle;
  }

  double startPointSize() {
    return 6;
  }

  BoardRefType horizontalReferencesType() {
    return this.refType;
  }

  BoardRefType verticalReferencesType() {
    return this.refType;
  }

  String boardReferenceFont() {
    return "Futura";
  }

  TextStyle boardRefernceStyle(double intersectionSize) {
    return TextStyle(
        color: BLACK_ISH,
        fontSize: intersectionSize / 2,
        fontFamily: "Futura");
  }

  Widget background() {
    return Image(
        image: AssetImage("assets/textures/shinkaya2.jpg"),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain);
  }

  StoneDrawers stones() {
    return stoneDrawers;
  }
}

class BoardRefType {
  String toText(int position) {
    return position.toString();
  }
}

abstract class StoneDrawer {
  void draw(Canvas canvas, BoardCoordinatesManager coordinatesManager,
      BoardCoordinate coordinate,
      {bool preview = false});
}

class WhiteStoneDrawer extends StoneDrawer {
  final Paint fillWhite = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..isAntiAlias = false;
  final Paint strokeBlack = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..isAntiAlias = true;

  WhiteStoneDrawer();

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordinatesManager,
      BoardCoordinate coordinate,
      {bool preview = false}) {
    var offset = coordinatesManager.fromCoordinate(coordinate);
    var radius = coordinatesManager.cellHeight * (preview ? 0.3 : 0.46);
    canvas.drawCircle(offset, radius, fillWhite);
    canvas.drawCircle(offset, radius, strokeBlack);
  }
}

class BlackStoneDrawer extends StoneDrawer {
  final Paint fillBlack = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  BlackStoneDrawer();

  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordinatesManager,
      BoardCoordinate coordinate,
      {bool preview = false}) {
    var offset = coordinatesManager.fromCoordinate(coordinate);
    var radius = coordinatesManager.cellHeight * (preview ? 0.3 : 0.46);
    canvas.drawCircle(offset, radius, fillBlack);
  }
}

class NoopDrawer extends StoneDrawer {
  @override
  void draw(Canvas canvas, BoardCoordinatesManager coordinatesManager,
      BoardCoordinate coordinate,
      {bool preview = false}) {}
}

class StoneDrawers {
  final StoneDrawer white = WhiteStoneDrawer();
  final StoneDrawer black = BlackStoneDrawer();
  final StoneDrawer noop = NoopDrawer();

  StoneDrawer drawerForColor(String? color) {
    if (color == "white") {
      return white;
    }
    if (color == "black") {
      return black;
    }
    return noop;
  }
}

class BoardThemes {
  static final BoardTheme DEFAUT = BoardTheme();
}
