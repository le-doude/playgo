import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class BoardWidget extends StatelessWidget {
  static final Logger logger = Logger();

  final Layout layout;
  final BoardTheme theme;

  BoardWidget(this.layout, this.theme);

  @override
  Widget build(BuildContext context) {
    var board = Board(this.layout, (b, s, c) => false, (s) => {}, (s, c) => {});
    var boardPainter = BoardPainter(ChangeNotifier(), board, this.theme);
    var customPaint = CustomPaint(painter: boardPainter, child: Container());
    var listener = Listener(
        onPointerHover: (event) =>
            boardPainter.onPointerHover(event.localPosition),
        // onPointerCancel: (event) => logger.d(event.toString()),
        // onPointerMove: (event) => logger.d(event.toString()),
        // onPointerUp: (event) => logger.d(event.toString()),
        onPointerUp: (event) => boardPainter.onPointerUp(event.localPosition),
        // onPointerSignal: (event) => logger.d(event.toString()),
        child: customPaint);
    var stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        this.theme.background(),
        listener,
      ],
    );
    var square = AspectRatio(aspectRatio: 1.0, child: stack);

    return square;
  }
}
