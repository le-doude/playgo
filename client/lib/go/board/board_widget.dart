import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/layout.dart';

import 'board_grid.dart';

class BoardWidget extends StatelessWidget {
  final Layout layout;

  BoardWidget(this.layout);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        backgroundImage(),
        gameGrid(),
      ],
    );
  }

  Widget backgroundImage() {
    return Image(
        image: AssetImage("assets/textures/shinkaya2.jpg"),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain);
  }

  Widget gameGrid() {
    return Center(
        child:
            CustomPaint(painter: BoardGrid(this.layout), child: Container()));
  }
}
