import 'package:flutter/widgets.dart';

/// Policy that decides when focus highlight (focus ring) should be visible.
///
/// This is intentionally small:
/// - It does NOT own focus (components do).
/// - It does NOT render anything (renderers do).
/// - It only answers "should we show focus highlight right now?"
abstract interface class HeadlessFocusHighlightPolicy {
  const HeadlessFocusHighlightPolicy();

  /// Whether focus highlight should be shown for the given [FocusHighlightMode].
  bool showFor(FocusHighlightMode mode);
}

/// Flutter-like policy:
/// show focus highlight only in keyboard navigation mode ("traditional").
final class HeadlessFlutterFocusHighlightPolicy
    implements HeadlessFocusHighlightPolicy {
  const HeadlessFlutterFocusHighlightPolicy();

  @override
  bool showFor(FocusHighlightMode mode) {
    return mode == FocusHighlightMode.traditional;
  }
}

/// Always show focus highlight when a widget is focused.
final class HeadlessAlwaysFocusHighlightPolicy
    implements HeadlessFocusHighlightPolicy {
  const HeadlessAlwaysFocusHighlightPolicy();

  @override
  bool showFor(FocusHighlightMode mode) => true;
}

/// Never show focus highlight (even when focused).
final class HeadlessNeverFocusHighlightPolicy
    implements HeadlessFocusHighlightPolicy {
  const HeadlessNeverFocusHighlightPolicy();

  @override
  bool showFor(FocusHighlightMode mode) => false;
}
