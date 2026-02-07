import 'package:flutter/widgets.dart';

import 'headless_focus_highlight_policy.dart';

/// Shared controller that tracks [FocusManager.highlightMode] and converts it
/// into a simple "show focus highlight" boolean via [HeadlessFocusHighlightPolicy].
///
/// Intended for deterministic rendering:
/// - Components subscribe to this controller and rebuild when focus highlight
///   visibility changes.
/// - Renderers receive `showFocusHighlight` as a plain flag (no global reads).
final class HeadlessFocusHighlightController extends ChangeNotifier {
  HeadlessFocusHighlightController({
    HeadlessFocusHighlightPolicy policy = const HeadlessFlutterFocusHighlightPolicy(),
    FocusManager? focusManager,
  })  : _policy = policy,
        _focusManager = focusManager ?? FocusManager.instance,
        _mode = (focusManager ?? FocusManager.instance).highlightMode {
    _focusManager.addListener(_handleFocusManagerChanged);
  }

  final HeadlessFocusHighlightPolicy _policy;
  final FocusManager _focusManager;
  FocusHighlightMode _mode;

  FocusHighlightMode get mode => _mode;

  bool get showFocusHighlight => _policy.showFor(_mode);

  void _handleFocusManagerChanged() {
    final next = _focusManager.highlightMode;
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _focusManager.removeListener(_handleFocusManagerChanged);
    super.dispose();
  }
}

