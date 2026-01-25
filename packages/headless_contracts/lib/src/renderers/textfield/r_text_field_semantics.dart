import 'package:flutter/widgets.dart';

/// Semantic information for TextField accessibility (v1).
///
/// Passed to renderer so it can build correct accessibility tree.
/// Base `Semantics(textField: true, ...)` is handled by the component.
///
/// Policy:
/// - `isObscured=true` → don't expose actual text content in semantics value.
@immutable
final class RTextFieldSemantics {
  const RTextFieldSemantics({
    this.label,
    this.hint,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.isObscured = false,
    this.errorText,
  });

  /// Accessible label (e.g., "Email address").
  final String? label;

  /// Hint text (placeholder).
  final String? hint;

  /// Whether the field is enabled.
  final bool isEnabled;

  /// Whether the field is read-only.
  final bool isReadOnly;

  /// Whether the text is obscured (password).
  ///
  /// When true, semantics should NOT reveal actual text content.
  final bool isObscured;

  /// Error text for screen reader announcement.
  final String? errorText;
}
