import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Resolves M3 focus overlay colors and border sides for the parity renderer.
///
/// Follows the same overlay colors used by Flutter's built-in M3 buttons
/// (see `_FilledButtonDefaultsM3`, `_OutlinedButtonDefaultsM3`, etc.).
abstract final class MaterialParityFocusOverlayResolver {
  /// Returns the M3 focus overlay color for the given [variant].
  ///
  /// Returns `null` when no overlay should be shown (not focused,
  /// focus highlight suppressed, or disabled).
  static Color? resolveOverlayColor({
    required BuildContext context,
    required RButtonVariant variant,
    required RButtonState state,
  }) {
    if (!state.isFocused || !state.showFocusHighlight || state.isDisabled) {
      return null;
    }
    final colors = Theme.of(context).colorScheme;
    return switch (variant) {
      RButtonVariant.filled => colors.onPrimary.withValues(alpha: 0.1),
      RButtonVariant.tonal =>
        colors.onSecondaryContainer.withValues(alpha: 0.1),
      RButtonVariant.outlined => colors.primary.withValues(alpha: 0.1),
      RButtonVariant.text => colors.primary.withValues(alpha: 0.1),
    };
  }

  /// Returns the M3 focus border side for the outlined variant.
  ///
  /// Returns `null` when no focus border change is needed
  /// (non-outlined variant, not focused, or disabled).
  static BorderSide? resolveFocusBorderSide({
    required BuildContext context,
    required RButtonVariant variant,
    required RButtonState state,
  }) {
    if (variant != RButtonVariant.outlined) return null;
    if (!state.isFocused || !state.showFocusHighlight || state.isDisabled) {
      return null;
    }
    return BorderSide(color: Theme.of(context).colorScheme.primary);
  }
}
