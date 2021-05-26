import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/game/event_handler.dart';

import 'board.dart';
import 'players.dart';
import 'rules.dart';

abstract class Game {
  final Board _board;
  final Rules _rules;
  final Players _players;
  final GameEventHandlers _eventHandlers = GameEventHandlers();
  late final Map<Player, Set<Stone>> _captures;

  Game(this._board, this._rules, this._players) {
    this._captures = Map.fromIterable(this._players.playerInOrder,
        key: (p) => p, value: (p) => Set());
  }

  Map<Player, Set<Stone>> get captures => _captures;

  Board get board => _board;

  Rules get rules => _rules;

  Players get players => _players;

  void resign(Player player); // can resign out of turn

  void place(Player player, Position coordinate);

  void pass(Player player);

  void nullify();

  void counting();

  bool allowed(Player player, Position coordinate);

  void withState(void Function(Board, Rules) func) {
    func.call(this._board, this._rules);
  }

  GameEventHandlers get eventHandlers => _eventHandlers;
}


