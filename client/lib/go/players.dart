import 'package:uuid/uuid.dart';

import 'board.dart';

typedef CurrentPlayerAction = void Function(Player player);

class Players {
  final List<Player> playerInOrder;
  int _turnCount;

  Players(this.playerInOrder, {int startAtTurn = 0}) : _turnCount = startAtTurn;

  Player get current =>
      this.playerInOrder[_turnCount % this.playerInOrder.length];

  void nextTurn() {
    _turnCount++;
  }
}

class Player {
  static final Uuid uuids = Uuid();
  final UuidValue _id;
  final String color;
  final Set<Stone> _captures = Set();

  Player(this.color) : this._id = uuids.v4obj();

  Stone get stone => Stone(color: color);

  UuidValue get id => _id;

  Set<Stone> get captures => _captures;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
