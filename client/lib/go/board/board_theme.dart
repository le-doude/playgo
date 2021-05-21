import 'dart:ui';

import 'package:flutter/material.dart';

import 'widget/theme/stone_drawer.dart';

class BoardTheme {
  static const Color BLACK_ISH = Color.fromARGB(255, 30, 30, 15);

  final BoardRefType refType = BoardRefType();
  final Paint inkLinesStyle = Paint()
    ..style = PaintingStyle.fill
    ..color = BLACK_ISH
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true;
  final StoneDrawers stoneDrawers = StoneDrawers();

  double get aspectRatio => 42/43;

  bool get drawReferences => true;

  Paint inkLinesPaint() {
    return this.inkLinesStyle;
  }

  double startPointSize(double cellSize) {
    return  cellSize * 0.09;
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

class BoardThemes {
  static final BoardTheme DEFAUT = BoardTheme();
}
