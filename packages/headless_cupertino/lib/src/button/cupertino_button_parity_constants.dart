import 'package:flutter/cupertino.dart';

/// Constants pinned from Flutter's CupertinoButton source (revision 8b87286849).
abstract final class CupertinoButtonParityConstants {
  static const Duration kAnimationDuration = Duration(milliseconds: 200);
  static const Duration kFadeOutDuration = Duration(milliseconds: 120);
  static const Duration kFadeInDuration = Duration(milliseconds: 180);
  static const double kDefaultPressedOpacity = 0.4;
  static const double kTintedOpacityLight = 0.12;
  static const double kTintedOpacityDark = 0.26;

  static const double kSmallMinHeight = 28.0;
  static const double kMediumMinHeight = 32.0;
  static const double kLargeMinHeight = 44.0;

  static const EdgeInsets kSmallPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const EdgeInsets kMediumPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const EdgeInsets kLargePadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  static const double kSmallBorderRadius = 6.0;
  static const double kMediumBorderRadius = 8.0;
  static const double kLargeBorderRadius = 10.0;
}
