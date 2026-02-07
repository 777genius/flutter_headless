import 'package:flutter/widgets.dart';

import 'headless_focus_highlight_controller.dart';

/// Provides a [HeadlessFocusHighlightController] to descendants.
///
/// Components can depend on this scope to rebuild deterministically when
/// focus highlight visibility changes.
final class HeadlessFocusHighlightScope
    extends InheritedNotifier<HeadlessFocusHighlightController> {
  const HeadlessFocusHighlightScope({
    required HeadlessFocusHighlightController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static HeadlessFocusHighlightController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<HeadlessFocusHighlightScope>()
        ?.notifier;
  }

  static HeadlessFocusHighlightController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        throw FlutterError(
          '[Headless] No HeadlessFocusHighlightScope found in widget tree.\n'
          'Fix: Wrap your app with HeadlessApp / HeadlessMaterialApp / HeadlessCupertinoApp.',
        );
      }
      return true;
    }());
    return controller!;
  }

  /// Convenience: returns whether focus highlight should be visible right now.
  ///
  /// If the scope is not installed, falls back to Flutter's [FocusManager].
  static bool showOf(BuildContext context) {
    return maybeOf(context)?.showFocusHighlight ??
        (FocusManager.instance.highlightMode == FocusHighlightMode.traditional);
  }
}
