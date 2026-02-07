import 'package:flutter/foundation.dart';

import 'headless_motion_theme.dart';

/// Centralized motion defaults for Headless presets.
///
/// This keeps durations/curves in one place so renderers and token resolvers
/// stay consistent and conformance can verify behavior.
@immutable
final class HeadlessMotionDefaults {
  const HeadlessMotionDefaults._();

  /// Default motion profile for Headless.
  ///
  /// Prefer using [HeadlessMotionTheme] directly. This alias exists to keep a
  /// stable API name for users who expect `HeadlessMotionDefaults`.
  static const HeadlessMotionTheme standard = HeadlessMotionTheme.standard();
}
