import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';

abstract class Rules {
  bool inKo(Stone stone, Position coordinate);

  bool hasRepetition(Board board);

  void updateState(Board board);

  factory Rules.japanese() {
    return JapaneseRules();
  }

  Rules();
}

class JapaneseRules extends Rules {
  bool inKo(Stone stone, Position coordinate) {
    return false;
  }

  bool hasRepetition(Board board) {
    return false;
  }

  void updateState(Board board) {}
}
