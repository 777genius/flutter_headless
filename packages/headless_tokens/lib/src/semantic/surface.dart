import 'package:meta/meta.dart';

/// Surface color semantic tokens.
///
/// Defines background colors for different elevation levels.
/// Values are ARGB integers (pure Dart, no Flutter dependency).
@immutable
final class SurfaceColors {
  const SurfaceColors();

  /// Base canvas background (e.g., page background)
  int get canvas => 0xFFFFFFFF;

  /// Default surface (e.g., card background)
  int get base => 0xFFF5F5F5;

  /// Elevated surface (e.g., raised card)
  int get raised => 0xFFFFFFFF;

  /// Overlay surface (e.g., modal backdrop)
  int get overlay => 0x80000000;
}
