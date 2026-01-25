import 'package:meta/meta.dart';

/// Motion duration semantic tokens.
///
/// Defines timing for animations and transitions.
@immutable
final class MotionDurations {
  const MotionDurations();

  /// Fast motion (micro-interactions, hover)
  Duration get fast => const Duration(milliseconds: 150);

  /// Normal motion (standard transitions)
  Duration get normal => const Duration(milliseconds: 300);
}
