import 'dart:ui';

import 'package:flutter/material.dart';

class BoardTheme {
  final BoardRefType refType = BoardRefType();
  final Paint inkLinesStyle = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black.withOpacity(0.7)
    ..strokeWidth = 2.1
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true;

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
        color: Colors.black,
        fontSize: intersectionSize / 2,
        fontFamily: "Futura");
  }

  ImageProvider loadBackgroundImage() {
    return AssetImage("assets/textures/shinkaya2.jpg");
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
