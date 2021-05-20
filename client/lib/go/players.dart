import 'package:uuid/uuid.dart';

import 'board.dart';

typedef CurrentPlayerAction = void Function(Player player);

abstract class Players {
  void withCurrentPlayer(CurrentPlayerAction action) {
    peekCurrentPlayer(action);
    _updateNextPlayer();
  }

  void peekCurrentPlayer(CurrentPlayerAction action) {
    action.call(_currentPlayer());
  }

  Player _currentPlayer();

  void _updateNextPlayer() {}
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
