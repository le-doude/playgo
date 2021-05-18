import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class BoardWidget extends StatelessWidget {
  final Layout layout;

  BoardWidget(this.layout);

  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        backgroundImage(),
        CustomPaint(
            painter: BoardPainter(this.layout, BoardThemes.DEFAUT),
            child: Container()),
      ],
    );
    return AspectRatio(aspectRatio: 1.0, child: stack);
  }

  Widget backgroundImage() {
    return Image(
        image: AssetImage("assets/textures/shinkaya2.jpg"),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain);
  }
}
