import 'package:play_go_client/go/board/widget/theme/board_reference_settings.dart';
import 'package:play_go_client/go/board/widget/theme/grid_settings.dart';

import 'widget/theme/background_settings.dart';
import 'widget/theme/stone_drawer.dart';

class BaseBoardTheme extends BoardTheme {
  final GridSettings gridSettings;
  final StoneDrawers stoneDrawers;
  final PreviewDrawers previewDrawers;
  final BoardReferenceSettings boardReferenceSettings;
  final BackgroundSettings backgroundSettings;
  final double boardAspectRatio;

  BaseBoardTheme(
      {GridSettings? gridSettings,
      StoneDrawers? stoneDrawers,
      PreviewDrawers? previewDrawers,
      BoardReferenceSettings? boardReferenceSettings,
      BackgroundSettings? backgroundSettings,
      double? boardAspectRatio})
      : gridSettings = gridSettings ?? BaseGridSettings(),
        stoneDrawers = stoneDrawers ?? StoneDrawers(),
        previewDrawers = previewDrawers ?? PreviewDrawers(),
        boardReferenceSettings =
            boardReferenceSettings ?? BaseBoardReferenceSettings(),
        backgroundSettings = backgroundSettings ?? BaseBackgroundSettings(),
        boardAspectRatio = boardAspectRatio ?? 42 / 43;
}

abstract class BoardTheme {
  GridSettings get gridSettings;

  StoneDrawers get stoneDrawers;

  PreviewDrawers get previewDrawers;

  BoardReferenceSettings get boardReferenceSettings;

  BackgroundSettings get backgroundSettings;

  double get boardAspectRatio;
}

class Themes {
  static final BoardTheme base = BaseBoardTheme();
}
