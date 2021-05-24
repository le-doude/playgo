import 'package:flutter/cupertino.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/widget/board_renderer.dart';
import 'package:play_go_client/go/board/widget/painter/board_coordinates_manager.dart';

typedef BoardEventCallback = void Function(Position coordinate);
typedef EventCallback = void Function();

class BoardWidget extends StatelessWidget {
  late final BoardRenderer _boardRenderer;

  final BoardEventCallback? onClick;
  final BoardEventCallback? onHover;
  final EventCallback? onMove;

  BoardWidget(
      {Key? key,
      required Board board,
      required BoardTheme theme,
      StonePreviewHolder? previewHolder,
      this.onClick,
      this.onHover,
      this.onMove})
      : super(key: key) {
    this._boardRenderer =
        BoardRenderer(board: board, theme: theme, previewHolder: previewHolder);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (event) {
        convert(event, this.onHover);
      },
      onPointerUp: (event) {
        convert(event, this.onClick);
      },
      onPointerMove: (event) {
        if (onMove != null) onMove!();
      },
      child: this._boardRenderer,
    );
  }

  void convert(PointerEvent event, BoardEventCallback? callback) {
    if (callback == null) return;
    var mngr = this._boardRenderer.coordinateManager;
    if (mngr.isInFrame(event.localPosition)) {
      callback(mngr.from(event.localPosition));
    }
  }
}
