import 'package:flutter/widgets.dart';

import 'board/layout.dart';
import 'board/theme.dart';
import 'rules/start_condition.dart';

class Board extends StatefulWidget {
  final Layout layout;
  final StartCondition startCondition;
  final Theme theme;

  const Board({Key key, this.layout, this.startCondition, this.theme})
      : super(key: key);

  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("not there");
  }
}
