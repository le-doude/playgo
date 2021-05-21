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

  void place(BoardCoordinate coordinate);

  void pass();
  
  bool allowed(BoardCoordinate coordinate);
}

class LocalGame extends Game {
  LocalGame(Board board, Rules rules, Players players)
      : super(board, rules, players);

  void place(BoardCoordinate coordinate) {
    var cp = this.players.current;
    if (_allowedMove(cp, coordinate)) {
      this.board.place(cp.stone, coordinate);
      this.players.nextTurn();
    }
  }

  void pass() {
    this.players.nextTurn();
  }

  bool _allowedMove(Player cp, BoardCoordinate coordinate) {
    return this._board.at(coordinate).empty;
  }

  @override
  bool allowed(BoardCoordinate coordinate) {
    return _allowedMove(this.players.current, coordinate);
  }
}
