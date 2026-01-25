import 'package:meta/meta.dart';

/// Status color semantic tokens.
///
/// Defines colors for feedback states (error, success, warning).
/// Values are ARGB integers (pure Dart, no Flutter dependency).
@immutable
final class StatusColors {
  const StatusColors();

  /// Danger/error foreground
  int get dangerFg => 0xFFD32F2F;

  /// Danger/error background
  int get dangerBg => 0xFFFFEBEE;

  /// Success foreground
  int get successFg => 0xFF388E3C;

  /// Success background
  int get successBg => 0xFFE8F5E9;
}
