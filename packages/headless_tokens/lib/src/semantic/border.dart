import 'package:meta/meta.dart';

/// Border color semantic tokens.
///
/// Defines colors for borders and dividers.
/// Values are ARGB integers (pure Dart, no Flutter dependency).
@immutable
final class BorderColors {
  const BorderColors();

  /// Subtle border (low contrast)
  int get subtle => 0xFFE0E0E0;

  /// Default border
  int get defaultColor => 0xFFBDBDBD;

  /// Focus ring color (accessibility)
  int get focus => 0xFF0066CC;
}
