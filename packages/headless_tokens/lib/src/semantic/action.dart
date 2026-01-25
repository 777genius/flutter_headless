import 'package:meta/meta.dart';

/// Action color semantic tokens.
///
/// Defines colors for interactive elements (buttons, links).
/// Values are ARGB integers (pure Dart, no Flutter dependency).
@immutable
final class ActionColors {
  const ActionColors();

  /// Primary action background
  int get primaryBg => 0xFF0066CC;

  /// Primary action foreground (text/icon on primaryBg)
  int get primaryFg => 0xFFFFFFFF;
}
