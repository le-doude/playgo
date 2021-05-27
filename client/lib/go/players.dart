import 'package:uuid/uuid.dart';

import 'board.dart';

typedef CurrentPlayerAction = void Function(Player player);

abstract class PlayerTurnManager {
  Player get current;

  Iterable<Player> get players;

  void nextTurn();

  PlayerTurnManager();

  factory PlayerTurnManager.local(List<Player> playerInOrder,
      {int startAtTurn = 0}) {
    return _LocalPlayerTurnManagerImpl(playerInOrder, startAtTurn: startAtTurn);
  }
}

class _LocalPlayerTurnManagerImpl extends PlayerTurnManager {
  final List<Player> playerInOrder;
  int _turnCount;

  _LocalPlayerTurnManagerImpl(this.playerInOrder, {int startAtTurn = 0})
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
  final bool _local;

  Player(this.color, {bool local = true})
      : this._id = uuids.v4obj(),
        this._local = local;

  Stone get stone => Stone(color: color);

  UuidValue get id => _id;

  bool get local => _local;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
