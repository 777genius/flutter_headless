import 'package:meta/meta.dart';

/// Text color semantic tokens.
///
/// Defines foreground colors for text content.
/// Values are ARGB integers (pure Dart, no Flutter dependency).
@immutable
final class TextColors {
  const TextColors();

  /// Primary text color (highest contrast)
  int get primary => 0xFF1A1A1A;

  /// Secondary text color (reduced emphasis)
  int get secondary => 0xFF757575;

  /// Disabled text color
  int get disabled => 0xFF9E9E9E;

  /// Inverse text (for dark backgrounds)
  int get inverse => 0xFFFFFFFF;
}
