import 'package:flutter/widgets.dart';

/// Dropdown specification (static, from widget props).
@immutable
final class RDropdownButtonSpec {
  const RDropdownButtonSpec({
    this.placeholder,
    this.semanticLabel,
    this.variant = RDropdownVariant.outlined,
    this.size = RDropdownSize.medium,
  });

  /// Placeholder text when no value is selected.
  final String? placeholder;

  /// Accessibility label (for screen readers).
  final String? semanticLabel;

  /// Visual variant.
  final RDropdownVariant variant;

  /// Size variant.
  final RDropdownSize size;
}

/// Dropdown visual variants.
enum RDropdownVariant {
  /// Outlined style with border.
  outlined,

  /// Filled style with background.
  filled,
}

/// Dropdown size variants.
enum RDropdownSize {
  /// Small size.
  small,

  /// Medium/default size.
  medium,

  /// Large size.
  large,
}
