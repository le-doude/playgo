import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class BoardWidget extends StatelessWidget {
  final Layout layout;
  final BoardTheme theme;

  BoardWidget(this.layout, this.theme);

  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        this.theme.background(),
        CustomPaint(
            painter: BoardPainter(
                this.layout,
                this.theme),
            child: Container()),
      ],
    );
    return AspectRatio(aspectRatio: 1.0, child: stack);
  }
}
