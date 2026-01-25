import 'package:flutter/foundation.dart';

import 'capability_overrides.dart';
import 'headless_theme.dart';

/// Headless theme wrapper that overrides specific capabilities.
///
/// This is intentionally simple (POLA):
/// - If an override exists for `T`, it wins.
/// - Otherwise, delegates to [base].
///
/// No merge policies, no partial composition.
@immutable
final class HeadlessThemeWithOverrides extends HeadlessTheme {
  const HeadlessThemeWithOverrides({
    required this.base,
    this.overrides = CapabilityOverrides.empty,
  });

  final HeadlessTheme base;
  final CapabilityOverrides overrides;

  @override
  T? capability<T>() {
    final overridden = overrides.get<T>();
    if (overridden != null) return overridden;
    return base.capability<T>();
  }

  @override
  String toString() {
    return 'HeadlessThemeWithOverrides(base: ${base.runtimeType})';
  }
}

