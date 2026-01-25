import 'dart:ui';

/// WCAG 2.1 accessibility constants.
///
/// These constants ensure compliance with Web Content Accessibility Guidelines.
/// See: https://www.w3.org/WAI/WCAG21/Understanding/target-size.html
abstract final class WcagConstants {
  /// Minimum touch target size per WCAG 2.1 Success Criterion 2.5.5.
  ///
  /// Interactive elements should be at least 44x44 CSS pixels to ensure
  /// they can be activated by users with motor impairments.
  static const Size kMinTouchTargetSize = Size(44, 44);
}
