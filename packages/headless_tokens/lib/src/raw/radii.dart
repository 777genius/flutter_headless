import 'package:meta/meta.dart';

/// Raw border radius tokens.
///
/// Values in logical pixels (dp). Generated from W3C Design Tokens.
@immutable
final class RadiiTokens {
  const RadiiTokens();

  /// 0dp - no rounding
  double get none => 0;

  /// 6dp - small rounding
  double get sm => 6;

  /// 10dp - medium rounding
  double get md => 10;

  /// 16dp - large rounding
  double get lg => 16;
}
