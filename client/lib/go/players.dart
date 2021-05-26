import 'package:uuid/uuid.dart';

import 'board.dart';

typedef CurrentPlayerAction = void Function(Player player);

abstract class Players {
  Player get current;

  Iterable<Player> get players;

  void nextTurn();
}

class LocalPlayers extends Players {
  final List<Player> playerInOrder;
  int _turnCount;

  LocalPlayers(this.playerInOrder, {int startAtTurn = 0})
      : _turnCount = startAtTurn;

  Player get current =>
      this.playerInOrder[_turnCount % this.playerInOrder.length];

  Iterable<Player> get players => Set.unmodifiable(this.playerInOrder);

  void nextTurn() {
    _turnCount++;
  }
}

class Player {
  static final Uuid uuids = Uuid();
  final UuidValue _id;
  final String color;

  Player(this.color) : this._id = uuids.v4obj();

  Stone get stone => Stone(color: color);

  UuidValue get id => _id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
