import 'package:meta/meta.dart';

import 'spacing.dart';
import 'radii.dart';
import 'durations.dart';

export 'spacing.dart';
export 'radii.dart';
export 'durations.dart';

/// Raw token storage (source: generated from W3C tokens by tooling).
///
/// v1 note: runtime parsing is out of scope; tokens are strongly typed.
///
/// Raw tokens are the primitive building blocks. Semantic tokens reference
/// these values to provide meaning (e.g., "action primary" instead of "blue 500").
@immutable
final class RawTokens {
  const RawTokens();

  /// Spacing tokens (0, 2, 4, 8, 12, 16, 24)
  SpacingTokens get spacing => const SpacingTokens();

  /// Border radius tokens (none, sm, md, lg)
  RadiiTokens get radii => const RadiiTokens();

  /// Animation duration tokens (fast, normal)
  DurationTokens get durations => const DurationTokens();
}
