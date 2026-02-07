import 'package:flutter/cupertino.dart';

/// Computes default Cupertino focus highlight color from the active color.
///
/// Flutter reference (`cupertino/constants.dart`):
/// - `kCupertinoFocusColorOpacity = 0.80`
/// - `kCupertinoFocusColorBrightness = 0.69`
/// - `kCupertinoFocusColorSaturation = 0.835`
Color resolveCupertinoSwitchFocusColor({
  required BuildContext context,
  required Color activeColor,
}) {
  const opacity = 0.80;
  const brightness = 0.69;
  const saturation = 0.835;

  final derived = HSLColor.fromColor(activeColor.withValues(alpha: opacity))
      .withLightness(brightness)
      .withSaturation(saturation)
      .toColor();

  return CupertinoDynamicColor.resolve(derived, context);
}
