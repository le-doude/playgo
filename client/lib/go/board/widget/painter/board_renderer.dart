import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/theme.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';
import 'package:play_go_client/go/board/widget/painter/board_painter.dart';
import 'package:play_go_client/go/board/widget/painter/stones_painter.dart';

class BoardRenderer extends StatelessWidget {
  final Board board;
  final BoardTheme theme;
  late final BoardPainter _boardPainter;
  late final StonesPainter _stonesPainter;

  BoardCoordinatesManager get coordinateManager =>
      _boardPainter.coordinatesManager;

  BoardRenderer({Key? key, required this.board, required this.theme})
      : super(key: key) {
    this._boardPainter = BoardPainter(this.board.layout, this.theme);
    this._stonesPainter = StonesPainter(this.board, this.theme);
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
            ),
          ],
        ));
  }
}
