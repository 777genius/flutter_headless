import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// App-level motion theme for Headless.
///
/// Designed to be **human-friendly**:
/// - one object you can set once for the whole app
/// - presets/components consume it consistently
/// - values are still carried through contracts via motion tokens
///
/// Provide it via capability overrides:
/// - `HeadlessThemeOverridesScope.only<HeadlessMotionTheme>(capability: ...)`
@immutable
final class HeadlessMotionTheme {
  const HeadlessMotionTheme({
    required this.dropdownMenu,
    required this.button,
  });

  /// Motion for dropdown menu open/close.
  final RDropdownMenuMotionTokens dropdownMenu;

  /// Motion for button visual state transitions.
  final RButtonMotionTokens button;

  /// Baseline "standard" motion (neutral, snappy).
  ///
  /// This is intended as the default for new presets and for apps
  /// that want a single consistent motion profile.
  const HeadlessMotionTheme.standard()
      : dropdownMenu = const RDropdownMenuMotionTokens(
          enterDuration: Duration(milliseconds: 150),
          exitDuration: Duration(milliseconds: 150),
          enterCurve: Curves.easeOut,
          exitCurve: Curves.easeOut,
          scaleBegin: 0.95,
        ),
        button = const RButtonMotionTokens(
          stateChangeDuration: Duration(milliseconds: 200),
        );

  /// Material preset defaults.
  static const HeadlessMotionTheme material = HeadlessMotionTheme.standard();

  /// Cupertino preset defaults (slightly softer timings/curves).
  static const HeadlessMotionTheme cupertino = HeadlessMotionTheme(
    dropdownMenu: RDropdownMenuMotionTokens(
      enterDuration: Duration(milliseconds: 200),
      exitDuration: Duration(milliseconds: 200),
      enterCurve: Curves.easeOut,
      exitCurve: Curves.easeOutCubic,
      scaleBegin: 0.9,
    ),
    button: RButtonMotionTokens(
      stateChangeDuration: Duration(milliseconds: 100),
    ),
  );
}
