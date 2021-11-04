import 'package:play_go_client/go/board/widget/theme/board_reference_settings.dart';
import 'package:play_go_client/go/board/widget/theme/grid_settings.dart';

import 'widget/theme/background_settings.dart';
import 'widget/theme/stone_drawer.dart';

class BaseBoardTheme extends BoardTheme {
  final GridSettings gridSettings;
  final StoneDrawers stoneDrawers;
  final StoneDrawers previewDrawers;
  final BoardReferenceSettings boardReferenceSettings;
  final BackgroundSettings backgroundSettings;
  final double boardAspectRatio;
  final double stoneSizeRatio;
  final double stoneShadowsOffsetRatio;

  BaseBoardTheme(
      {GridSettings? gridSettings,
      StoneDrawers? stoneDrawers,
      StoneDrawers? previewDrawers,
      BoardReferenceSettings? boardReferenceSettings,
      BackgroundSettings? backgroundSettings,
      double boardAspectRatio = 1.0,
      double stoneSizeRatio = 0.93,
      double stoneShadowsOffsetRatio = 0.05})
      : gridSettings = gridSettings ?? BaseGridSettings(),
        boardReferenceSettings =
            boardReferenceSettings ?? BaseBoardReferenceSettings(),
        backgroundSettings = backgroundSettings ?? BaseBackgroundSettings(),
        boardAspectRatio = boardAspectRatio,
        stoneSizeRatio = stoneSizeRatio,
        stoneShadowsOffsetRatio = stoneShadowsOffsetRatio,
        stoneDrawers = stoneDrawers ?? StoneDrawers(stoneSizeRatio),
        previewDrawers =
            previewDrawers ?? StoneDrawers(stoneSizeRatio, opacity: 0.75);
}

abstract class BoardTheme {
  GridSettings get gridSettings;

  StoneDrawers get stoneDrawers;

  StoneDrawers get previewDrawers;

  BoardReferenceSettings get boardReferenceSettings;

  BackgroundSettings get backgroundSettings;

  double get boardAspectRatio;

  double get stoneSizeRatio;

  double get stoneShadowsOffsetRatio;
}

class Themes {
  static final BoardTheme base = BaseBoardTheme();
}
