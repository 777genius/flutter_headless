import 'package:flutter/widgets.dart';

import '../../theme_mode_scope.dart';
import 'flutter_cupertino_buttons_content.dart';
import 'flutter_material_buttons_content.dart';

/// Displays standard Flutter buttons for side-by-side focus/Tab comparison
/// with headless buttons.
///
/// Switches between Material and Cupertino buttons based on [ThemeModeScope].
final class FlutterStandardButtonsSection extends StatelessWidget {
  const FlutterStandardButtonsSection({
    super.key,
    required this.isDisabled,
    required this.onPressed,
  });

  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;
    return isCupertino
        ? FlutterCupertinoButtonsContent(
            isDisabled: isDisabled,
            onPressed: onPressed,
          )
        : FlutterMaterialButtonsContent(
            isDisabled: isDisabled,
            onPressed: onPressed,
          );
  }
}
