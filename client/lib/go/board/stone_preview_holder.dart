import 'package:flutter/cupertino.dart';
import 'package:play_go_client/go/board/layout.dart';

class StonePreviewHolder extends ValueNotifier<StonePreview?> {
  StonePreviewHolder(StonePreview? value) : super(value);

  void clear() {
    this.value = null;
  }
}

class StonePreview {
  final String color;
  final Position coordinate;

  StonePreview(this.color, this.coordinate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StonePreview &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          coordinate == other.coordinate;

  @override
  int get hashCode => color.hashCode ^ coordinate.hashCode;
}
