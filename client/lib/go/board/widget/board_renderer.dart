import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/board_painter.dart';
import 'package:play_go_client/go/board/widget/painter/stones_painter.dart';

class BoardRenderer extends StatelessWidget {
  final BoardTheme theme;
  late final BoardPainter _boardPainter;
  late final StonesPainter _stonesPainter;

  BoardCoordinates get coordinateManager =>
      _stonesPainter.coordinatesManager;

  BoardRenderer(
      {Key? key,
      required BoardState board,
      required this.theme,
      required Layout layout,
      StonePreviewHolder? previewHolder})
      : super(key: key) {
    this._boardPainter = BoardPainter(layout, this.theme);
    this._stonesPainter =
        StonesPainter(board, this.theme, layout, previewHolder: previewHolder);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: this.theme.boardAspectRatio,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            (this.theme.backgroundSettings.background()),
            CustomPaint(
                child: Container(),
                painter: this._boardPainter,
                foregroundPainter: this._stonesPainter)
          ],
        ));
  }
}
