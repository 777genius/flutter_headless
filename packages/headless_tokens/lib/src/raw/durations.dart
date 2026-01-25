import 'package:meta/meta.dart';

/// Raw duration tokens for animations/transitions.
///
/// Generated from W3C Design Tokens.
@immutable
final class DurationTokens {
  const DurationTokens();

  /// 150ms - quick micro-interactions
  Duration get fast => const Duration(milliseconds: 150);

  /// 300ms - standard transitions
  Duration get normal => const Duration(milliseconds: 300);
}
