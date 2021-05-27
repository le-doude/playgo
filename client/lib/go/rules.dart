import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';

class Rules {
  bool inKo(Stone stone, Position coordinate) {
    return false;
  }

  bool hasRepetition(Board board) {
    return false;
  }

  void updateState(Board board) {}
}
