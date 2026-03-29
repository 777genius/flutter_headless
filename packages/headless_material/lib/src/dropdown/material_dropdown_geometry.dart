import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../overrides/material_override_types.dart';
import 'material_dropdown_density.dart';

final class MaterialDropdownTriggerSizeTokens {
  const MaterialDropdownTriggerSizeTokens({
    required this.textStyle,
    required this.padding,
  });

  final TextStyle textStyle;
  final EdgeInsets padding;
}

MaterialDropdownTriggerSizeTokens materialDropdownTriggerSizeTokens(
  RDropdownSize size,
  TextTheme text,
) {
  switch (size) {
    case RDropdownSize.small:
      return MaterialDropdownTriggerSizeTokens(
        textStyle: text.bodySmall ?? const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    case RDropdownSize.medium:
      return MaterialDropdownTriggerSizeTokens(
        textStyle: text.bodyMedium ?? const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    case RDropdownSize.large:
      return MaterialDropdownTriggerSizeTokens(
        textStyle: text.bodyLarge ?? const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );
  }
}

Size materialDropdownResolveMinSize({
  required BoxConstraints? constraints,
  required MaterialComponentDensity? density,
  required Size? override,
}) {
  const defaultMinSize = Size(48, 48);
  final base = density == null
      ? defaultMinSize
      : MaterialDropdownDensity.applyMinSize(defaultMinSize, density);
  final withOverride = override ?? base;

  if (constraints != null) {
    return Size(
      math.max(
        withOverride.width,
        constraints.minWidth > 0 ? constraints.minWidth : withOverride.width,
      ),
      math.max(
        withOverride.height,
        constraints.minHeight > 0 ? constraints.minHeight : withOverride.height,
      ),
    );
  }

  return withOverride;
}

BorderRadius? materialDropdownResolveCornerRadius(MaterialCornerStyle? style) {
  switch (style) {
    case MaterialCornerStyle.sharp:
      return const BorderRadius.all(Radius.circular(4));
    case MaterialCornerStyle.rounded:
      return const BorderRadius.all(Radius.circular(12));
    case MaterialCornerStyle.pill:
      return const BorderRadius.all(Radius.circular(999));
    case null:
      return null;
  }
}
