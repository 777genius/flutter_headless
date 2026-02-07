import 'package:headless_contracts/headless_contracts.dart';

/// Adapts [RTextFieldState] to the flag set expected by [InputDecorator].
///
/// Pure data adapter — no widget tree, no side effects.
class MaterialTextFieldStateAdapter {
  const MaterialTextFieldStateAdapter._();

  /// Whether the field is currently focused.
  static bool isFocused(RTextFieldState state) => state.isFocused;

  /// Whether the pointer is hovering over the field.
  static bool isHovering(RTextFieldState state) => state.isHovered;

  /// Whether the field text is empty (no user input).
  static bool isEmpty(RTextFieldState state) => !state.hasText;

  /// Whether the field is enabled (interactive).
  static bool isEnabled(RTextFieldState state) => !state.isDisabled;

  /// Whether the field should expand to fill available space.
  ///
  /// Always `false` in v1 — requires `RTextFieldSpec.expands` (not yet in contracts).
  /// Flutter: `TextField.expands` requires `maxLines == null && minLines == null`.
  static bool expands(RTextFieldState state) => false;
}
