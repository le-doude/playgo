import 'package:flutter/cupertino.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/board/widget/board_renderer.dart';

typedef BoardEventCallback = void Function(Position coordinate);
typedef EventCallback = void Function();

class BoardWidget extends StatelessWidget {
  late final BoardRenderer _boardRenderer;

  final BoardEventCallback? onClick;
  final BoardEventCallback? onHover;
  final EventCallback? onMoveAway;

  BoardWidget(
      {Key? key,
      required BoardNotifier board,
      required BoardTheme theme,
      required Layout layout,
      required StonePreviewHolder previewHolder,
      this.onClick,
      this.onHover,
      this.onMoveAway})
      : super(key: key) {
    this._boardRenderer = BoardRenderer(
        board: board,
        theme: theme,
        layout: layout,
        previewHolder: previewHolder);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        child: Listener(
          onPointerUp: (event) => pointerToPosition(event, this.onClick),
          child: this._boardRenderer,
        ),
        opaque: false,
        onHover: (event) => pointerToPosition(event, this.onHover),
        onExit: (event) => this.onMoveAway?.call());
  }

  void pointerToPosition(PointerEvent event, BoardEventCallback? callback) {
    if (callback == null) return;
    var mngr = this._boardRenderer.coordinateManager;
    if (mngr.isInFrame(event.localPosition)) {
      callback(mngr.from(event.localPosition));
    }
  }
}
