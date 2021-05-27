import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/board_painter.dart';
import 'package:play_go_client/go/board/widget/painter/stones_painter.dart';
import 'package:play_go_client/go/board/widget/painter/stones_preview_painter.dart';

class BoardRenderer extends StatelessWidget {
  final BoardTheme theme;
  late final BoardPainter _boardPainter;
  late final StonesPainter _stonesPainter;
  late final StonesPreviewPainter _previewPainter;

  BoardCoordinates get coordinateManager => _stonesPainter.coordinatesManager;

  BoardRenderer(
      {Key? key,
      required BoardNotifier board,
      required this.theme,
      required Layout layout,
      required StonePreviewHolder previewHolder})
      : super(key: key) {
    this._boardPainter = BoardPainter(layout, this.theme);
    this._stonesPainter = StonesPainter(board, this.theme, layout);
    this._previewPainter = StonesPreviewPainter(theme, layout, previewHolder);
  }

  @override
  Widget build(BuildContext context) {
    var child = Container();
    return AspectRatio(
        aspectRatio: this.theme.boardAspectRatio,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            (this.theme.backgroundSettings.background()),
            CustomPaint(child: child, painter: this._boardPainter),
            CustomPaint(child: child, painter: this._stonesPainter),
            CustomPaint(child: child, painter: this._previewPainter)
          ],
        ));
  }
}
