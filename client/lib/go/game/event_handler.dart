import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/players.dart';

class GameEventHandlers {
  final GameEventNotifier<GameOverEvent> _gameOverNotifier =
      GameEventNotifier<GameOverEvent>();

  final GameEventNotifier<GameNullifiedEvent> _gameNullifiedNotifier =
      GameEventNotifier<GameNullifiedEvent>();

  final GameEventNotifier<ResignedEvent> _resignedNotifier =
      GameEventNotifier<ResignedEvent>();

  final GameEventNotifier<PassedEvent> _passedNotifier =
      GameEventNotifier<PassedEvent>();

  final GameEventNotifier<StonePlacedEvent> _stonePlacedNotifier =
      GameEventNotifier<StonePlacedEvent>();

  GameEventNotifier<GameOverEvent> get gameOverNotifier => _gameOverNotifier;

  GameEventNotifier<GameNullifiedEvent> get gameNullifiedNotifier =>
      _gameNullifiedNotifier;

  GameEventNotifier<ResignedEvent> get resignedNotifier => _resignedNotifier;

  GameEventNotifier<PassedEvent> get passedNotifier => _passedNotifier;

  GameEventNotifier<StonePlacedEvent> get stonePlacedNotifier =>
      _stonePlacedNotifier;
}

class GameEventNotifier<T extends GameEvent> {
  final Set<void Function(T event)> _listeners = Set();

  void notify(T event) {
    this._listeners.forEach((listener) => listener(event));
  }

  void addListener(void Function(T event) listener) {
    this._listeners.add(listener);
  }

  void removeListener(void Function(T event) listener) {
    this._listeners.remove(listener);
  }
}

abstract class GameEvent {
  int get moveNumber;

  DateTime get time;
}

class GameOverEvent extends GameEvent {
  final int moveNumber;
  final Player winner;
  final Player loser;
  final double scoreDifference;
  final bool resignation;
  final DateTime time;

  GameOverEvent(this.moveNumber, this.winner, this.loser, this.scoreDifference,
      this.resignation, this.time);
}

class GameNullifiedEvent extends GameEvent {
  final int moveNumber;
  final StoneColors reason;
  final DateTime time;

  GameNullifiedEvent(this.moveNumber, this.reason, this.time);
}

class ResignedEvent extends GameEvent {
  final int moveNumber;
  final Player resignedBy;
  final DateTime time;

  ResignedEvent(this.moveNumber, this.resignedBy, this.time);
}

class PassedEvent extends GameEvent {
  final int moveNumber;
  final Player passedBy;
  final StoneColors color;
  final DateTime time;

  PassedEvent(this.moveNumber, this.passedBy, this.color, this.time);
}

class StonePlacedEvent extends GameEvent {
  final int moveNumber;
  final Player placedBy;
  final StoneColors color;
  final Position position;
  final Set<Stone> capturedStones;
  final DateTime time;

  StonePlacedEvent(this.moveNumber, this.placedBy, this.color, this.position,
      this.capturedStones, this.time);
}
