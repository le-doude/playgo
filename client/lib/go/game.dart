import 'package:play_go_client/go/board/layout.dart';

import 'players.dart';
import 'rules.dart';
import 'board.dart';

abstract class Game {
  final Board _board;
  final Rules _rules;
  final Players _players;

  Game(this._board, this._rules, this._players);

  Board get board => _board;

  Rules get rules => _rules;

  Players get players => _players;

  void place(Position coordinate);

  void pass();

  bool allowed(Position coordinate);
}

class LocalGame extends Game {
  LocalGame(Board board, Rules rules, Players players)
      : super(board, rules, players);

  void place(Position coordinate) {
    var cp = this.players.current;
    if (_allowedMove(cp, coordinate)) {
      var caps = this.board.placeWithCapture(cp.stone, coordinate);
      this.players.current.captures.addAll(caps);
      this.rules.updateState(this._board);
      this.players.nextTurn();
    }
  }

  void pass() {
    this.rules.pass(this.players.current);
    this.players.nextTurn();
  }

  bool _allowedMove(Player cp, Position coordinate) {
    return this._board.canPlaceWithCapture(cp.stone, coordinate) &&
        !this._rules.inKo(cp.stone, coordinate);
  }

  @override
  bool allowed(Position coordinate) {
    return _allowedMove(this.players.current, coordinate);
  }
}
