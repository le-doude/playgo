import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/game.dart';
import 'package:play_go_client/go/game/event_handler.dart';
import 'package:play_go_client/go/players.dart';
import 'package:play_go_client/go/rules.dart';

class LocalGame extends Game {
  LocalGame(Board board, Rules rules, Players players)
      : super(board, rules, players);

  void place(Player player, Position coordinate) {
    if (player != this.players.current) {
      return;
    }
    if (_allowedMove(player, coordinate)) {
      _play(player, coordinate);
      this.players.nextTurn();
      _checkForDrawByRepetition();
    }
  }

  void _play(Player player, Position coordinate) {
    var caps = this.board.place(player.stone, coordinate);
    this.captures[player]?.addAll(caps);
    this.eventHandlers.stonePlacedNotifier.notify(StonePlacedEvent(
        -1, player, player.color, coordinate, caps, DateTime.now()));
  }

  void _checkForDrawByRepetition() {
    if (this.rules.hasRepetition(this.board)) {
      nullify();
    }
  }

  void pass(Player player) {
    if (player != this.players.current) {
      return;
    }
    this
        .eventHandlers
        .passedNotifier
        .notify(PassedEvent(-1, player, player.color, DateTime.now()));
    this.players.nextTurn();
  }

  bool _allowedMove(Player player, Position coordinate) {
    return this.board.canPlace(player.stone, coordinate) &&
        !this.rules.inKo(player.stone, coordinate);
  }

  @override
  bool allowed(Player player, Position coordinate) {
    return _allowedMove(player, coordinate);
  }

  @override
  void resign(Player player) {
    // TODO: implement resign
    this
        .eventHandlers
        .resignedNotifier
        .notify(ResignedEvent(-1, player, DateTime.now()));
  }

  @override
  void nullify() {
    // TODO: implement nullify
  }

  @override
  void counting() {
    // TODO: implement counting
  }
}
