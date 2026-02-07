import 'package:flutter/widgets.dart';

/// Component types that can have a custom tap target size.
enum HeadlessTapTargetComponent {
  /// Button components.
  button,
}

/// Contract for platform-specific minimum tap target sizing.
///
/// Separates visual size from hit-test area: the visual element may be
/// smaller than the minimum tap target, but the gesture detector must cover
/// at least this size for accessibility compliance.
///
/// Presets implement this to match platform guidelines:
/// - Material: 48dp padded / Size.zero shrinkWrap (per density)
/// - Cupertino: 44x44 (HIG minimum)
abstract interface class HeadlessTapTargetPolicy {
  /// Returns the minimum tap target size for the given [component].
  Size minTapTargetSize({
    required BuildContext context,
    required HeadlessTapTargetComponent component,
  });
}
