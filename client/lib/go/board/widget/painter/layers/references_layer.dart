import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/layout.dart';

import '../board_coordinates_manager.dart';
import 'board_layer.dart';

class ReferencesLayer extends BoardLayer{
  static final Logger logger = Logger();

  final Layout layout;
  final BoardTheme theme;

  ReferencesLayer(this.layout, this.theme) : super(2);

  void draw(Canvas canvas, BoardCoordinatesManager intersections) {
    if(!this.theme.boardReferenceSettings.enabled) {
      return;
    }
    var top = intersections.outerFrame.top +
        intersections.innerFrame.top ;
    top /= 2;
    var left = intersections.outerFrame.left +
        intersections.innerFrame.left;
    left /= 2;

    for (int i = 0; i < this.layout.columns; i++) {
      var offset = intersections.get(i, 0);
      var pOffset = Offset(offset.dx, top);
      _drawText(canvas, this.theme.boardReferenceSettings.horizontal(i + 1),
          pOffset, intersections.cellHeight);
    }
    for (int i = 0; i < this.layout.rows; i++) {
      var offset = intersections.get(0, i);
      var pOffset = Offset(left, offset.dy);
      _drawText(canvas, this.theme.boardReferenceSettings.vertical(i + 1),
          pOffset, intersections.cellHeight);
    }
  }

  void _drawText(
      Canvas canvas, String reference, Offset textCenter, double cellSize) {
    var painter = TextPainter(
        text: TextSpan(
            text: reference, style: this.theme.boardReferenceSettings.textStyle(cellSize)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
    );
    painter.layout();
    var textRect = _calculateTextRect(painter, textCenter, reference.length);
    painter.paint(canvas, textRect.topLeft);
  }

  Rect _calculateTextRect(TextPainter painter, Offset textCenter, int textLenght) {
    var selection = painter.getBoxesForSelection(
        TextSelection(baseOffset: 0, extentOffset: textLenght));
    var rect = selection.first.toRect();
    return  Rect.fromCenter(
        center: textCenter, width: rect.width, height: rect.height);
  }

  Rect _calculateTextRect_LineMetrics(TextPainter painter, Offset textCenter) {
      var metrics = painter.computeLineMetrics().first;
      var txtW = metrics.width;
      var txtH =  metrics.height;
      return  Rect.fromCenter(
          center: textCenter, width: txtW, height: txtH);
  }
}
