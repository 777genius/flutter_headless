import 'package:flutter/widgets.dart';

import 'headless_focus_hover_controller.dart';

/// Shared widget wrapper for hover handling.
///
/// Focus changes are expected to be wired from the component (e.g. FocusNode listener).
final class HeadlessHoverRegion extends StatelessWidget {
  const HeadlessHoverRegion({
    required this.controller,
    required this.enabled,
    required this.child,
    this.cursorWhenEnabled,
    this.cursorWhenDisabled,
    super.key,
  });

  final HeadlessFocusHoverController controller;
  final bool enabled;
  final MouseCursor? cursorWhenEnabled;
  final MouseCursor? cursorWhenDisabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shouldBeDisabled = !enabled;
    if (controller.state.isDisabled != shouldBeDisabled) {
      // Avoid notifying listeners during build. Consumers may call setState()
      // in response to controller changes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setDisabled(shouldBeDisabled);
      });
    }

    return MouseRegion(
      onEnter: (_) => controller.handleMouseEnter(),
      onExit: (_) => controller.handleMouseExit(),
      cursor: enabled
          ? (cursorWhenEnabled ?? MouseCursor.defer)
          : (cursorWhenDisabled ?? MouseCursor.defer),
      child: child,
    );
  }
}

