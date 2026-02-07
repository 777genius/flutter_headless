import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Resolves prefix/suffix visibility based on [RTextFieldOverlayVisibilityMode]
/// and current [RTextFieldState].
///
/// Pure function — no side effects, no Flutter dependencies beyond [Widget].
class MaterialTextFieldAffixVisibilityResolver {
  const MaterialTextFieldAffixVisibilityResolver._();

  /// Returns the widget if it should be visible, `null` otherwise.
  ///
  /// [mode] — visibility policy from [RTextFieldSpec].
  /// [state] — current interaction state.
  /// [widget] — the affix widget to conditionally show.
  static Widget? resolve({
    required RTextFieldOverlayVisibilityMode mode,
    required RTextFieldState state,
    required Widget? widget,
  }) {
    if (widget == null) return null;

    return switch (mode) {
      RTextFieldOverlayVisibilityMode.never => null,
      RTextFieldOverlayVisibilityMode.always => widget,
      RTextFieldOverlayVisibilityMode.whileEditing =>
        state.isFocused ? widget : null,
      RTextFieldOverlayVisibilityMode.notEditing =>
        state.isFocused ? null : widget,
    };
  }
}
