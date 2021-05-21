import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/board_painter.dart';
import 'package:play_go_client/go/board/widget/painter/stones_painter.dart';

class BoardRenderer extends StatelessWidget {
  final BoardTheme theme;
  late final BoardPainter _boardPainter;
  late final StonesPainter _stonesPainter;

  BoardCoordinatesManager get coordinateManager =>
      _stonesPainter.coordinatesManager;

  BoardRenderer(
      {Key? key,
      required Board board,
      required this.theme,
      StonePreviewHolder? previewHolder})
      : super(key: key) {
    this._boardPainter = BoardPainter(board.layout, this.theme);
    this._stonesPainter =
        StonesPainter(board, this.theme, previewHolder: previewHolder);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: this.theme.aspectRatio,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            this.theme.background(),
            CustomPaint(
              child: Container(),
              painter: this._boardPainter,
              foregroundPainter: this._stonesPainter,
              isComplex: true,
              willChange: true,
            ),
          ],
        ));
  }
}