import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'material_text_field_affix_visibility_resolver.dart';
import '../overrides/material_text_field_overrides.dart';

/// Builds [InputDecoration] from [RTextFieldSpec], [RTextFieldSlots], and
/// interaction state.
///
/// Pure builder — no widget tree, deterministic output.
///
/// Variant mapping:
/// - `underlined` → [UnderlineInputBorder], `filled: false`
/// - `outlined`   → [OutlineInputBorder], `filled: false`
/// - `filled`     → [UnderlineInputBorder], `filled: true`
///
/// Content padding, label style, floating label style, fill color, and
/// constraints are intentionally NOT set — M3 defaults handle them.
class MaterialTextFieldDecorationFactory {
  const MaterialTextFieldDecorationFactory._();

  /// Creates an [InputDecoration] that maps renderless contracts to
  /// Flutter Material 3 input decoration.
  static InputDecoration create({
    required RTextFieldSpec spec,
    required RTextFieldState state,
    RTextFieldSlots? slots,
    RenderOverrides? overrides,
  }) {
    final isEnabled = !state.isDisabled;
    final materialOverrides = overrides?.get<MaterialTextFieldOverrides>();

    final prefix = MaterialTextFieldAffixVisibilityResolver.resolve(
      mode: spec.prefixMode,
      state: state,
      widget: slots?.prefix,
    );

    final suffix = MaterialTextFieldAffixVisibilityResolver.resolve(
      mode: spec.suffixMode,
      state: state,
      widget: slots?.suffix,
    );

    final decoration = InputDecoration(
      hintText: spec.placeholder,
      hintMaxLines: spec.maxLines,
      labelText: spec.label,
      helperText: spec.helperText,
      errorText: spec.errorText,
      enabled: isEnabled,
      filled: spec.variant == RTextFieldVariant.filled,
      border: _borderForVariant(spec.variant),
      prefixIcon: slots?.leading,
      suffixIcon: slots?.trailing,
      prefix: prefix,
      suffix: suffix,
    );

    if (materialOverrides == null || !materialOverrides.hasOverrides) {
      return decoration;
    }

    // Opt-in: allow preset-specific decoration tweaks (breaks strict parity).
    return decoration.copyWith(
      filled: materialOverrides.filled,
      fillColor: materialOverrides.fillColor,
      contentPadding: materialOverrides.contentPadding,
      border: materialOverrides.border,
      enabledBorder: materialOverrides.enabledBorder,
      focusedBorder: materialOverrides.focusedBorder,
      errorBorder: materialOverrides.errorBorder,
      focusedErrorBorder: materialOverrides.focusedErrorBorder,
    );
  }

  static InputBorder _borderForVariant(RTextFieldVariant variant) {
    return switch (variant) {
      RTextFieldVariant.underlined => const UnderlineInputBorder(),
      RTextFieldVariant.outlined => const OutlineInputBorder(),
      RTextFieldVariant.filled => const UnderlineInputBorder(),
    };
  }
}
