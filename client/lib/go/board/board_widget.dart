import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stones_drawer.dart';
import 'package:play_go_client/go/board/theme.dart';

import 'board_painter.dart';

class BoardWidget extends StatelessWidget {
  final Layout layout;
  final BoardTheme theme;

  BoardWidget(this.layout, this.theme);

  bool NoKoPredicate(Board board, Stone stone, BoardCoordinate coordinate) {
    return false;
  }

  void NoopCaptureCallback(Stone stone) {}

  void NoopMoveCallback(Stone stone, BoardCoordinate coordinate) {}

  @override
  Widget build(BuildContext context) {
    var board = Board(
        this.layout, NoKoPredicate, NoopCaptureCallback, NoopMoveCallback);
    var stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        this.theme.background(),
        CustomPaint(
            painter: BoardPainter(this.layout, this.theme,
                layeredComponents: [StonesDrawer(layout, theme, board)]),
            child: Container()),
      ],
    );

    board.place(Stone(color: "white"), BoardCoordinate(3, 3));
    board.place(Stone(color: "white"), BoardCoordinate(4, 3));
    board.place(Stone(color: "white"), BoardCoordinate(5, 3));
    board.place(Stone(color: "white"), BoardCoordinate(10, 7));
    board.place(Stone(color: "white"), BoardCoordinate(10, 8));
    board.place(Stone(color: "white"), BoardCoordinate(11, 8));

    board.place(Stone(color: "black"), BoardCoordinate(15, 3));
    board.place(Stone(color: "black"), BoardCoordinate(16, 3));
    board.place(Stone(color: "black"), BoardCoordinate(17, 3));
    board.place(Stone(color: "black"), BoardCoordinate(10, 11));
    board.place(Stone(color: "black"), BoardCoordinate(10, 12));
    board.place(Stone(color: "black"), BoardCoordinate(11, 12));
    return AspectRatio(aspectRatio: 1.0, child: stack);
  }
}
