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
}

class LocalGame extends Game {
  LocalGame(Board board, Rules rules, Players players) : super(board, rules, players);
}

class OnlineGame extends Game {
  OnlineGame(Board board, Rules rules, Players players) : super(board, rules, players);
}
