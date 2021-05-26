import 'package:flutter/material.dart';
import 'package:play_go_client/go/board/widget/theme/go_colors.dart';

typedef ReferenceFormatter = String Function(int index);

abstract class BoardReferenceSettings {
  bool get enabled;

  double get marginRatio;

  ReferenceFormatter get vertical;

  ReferenceFormatter get horizontal;

  TextStyle textStyle(double intersectionSize);
}

class BaseBoardReferenceSettings extends BoardReferenceSettings {
  static final ReferenceFormatter _defaultFormatter = (i) => i.toString();

  final bool enabled;
  final double marginRatio;
  final ReferenceFormatter vertical;
  final ReferenceFormatter horizontal;
  final Color textColor;
  final String fontStyle;
  final List<String> alternateFontStyle;
  final double fontSizeRatio;

  BaseBoardReferenceSettings(
      {bool enabled = true,
      double marginRatio = 0.9,
      ReferenceFormatter? vertical,
      ReferenceFormatter? horizontal,
      Color? textColor,
      String fontStyle = "Futura",
      List<String>? alternateFontStyle,
      double fontSizeRatio = 0.5})
      : enabled = enabled,
        marginRatio = marginRatio,
        vertical = vertical ?? _defaultFormatter,
        horizontal = horizontal ?? _defaultFormatter,
        textColor = textColor ?? GoColors.DARKEST_INK,
        fontStyle = fontStyle,
        alternateFontStyle = alternateFontStyle ?? [],
        fontSizeRatio = fontSizeRatio;

  TextStyle textStyle(double intersectionSize) {
    return TextStyle(
        color: GoColors.DARKEST_INK,
        fontSize: intersectionSize * this.fontSizeRatio,
        fontFamily: this.fontStyle,
        fontFamilyFallback: this.alternateFontStyle);
  }
}
