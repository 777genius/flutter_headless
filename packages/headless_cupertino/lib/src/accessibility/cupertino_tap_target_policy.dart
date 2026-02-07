import 'package:flutter/widgets.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino tap target policy based on Apple HIG minimum 44x44 points.
class CupertinoTapTargetPolicy implements HeadlessTapTargetPolicy {
  const CupertinoTapTargetPolicy();

  static const double _kMinTargetDimension = 44.0;

  @override
  Size minTapTargetSize({
    required BuildContext context,
    required HeadlessTapTargetComponent component,
  }) {
    return const Size(_kMinTargetDimension, _kMinTargetDimension);
  }
}
