import 'package:flutter/widgets.dart';

import 'headless_pressable_controller.dart';
import 'headless_pressable_key_event_adapter.dart';
import 'headless_pressable_visual_effects.dart';

/// Shared widget wrapper for pressable surfaces.
///
/// Keeps widget trees consistent across components and centralizes
/// focus/hover/pressed plumbing.
///
/// Notes (v1):
/// - This widget is responsible for pointer + keyboard interaction plumbing.
/// - Accessibility activation (`SemanticsAction.tap`) must be provided by the
///   component via `Semantics(onTap: ...)`, not here and not in renderers.
final class HeadlessPressableRegion extends StatelessWidget {
  const HeadlessPressableRegion({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.enabled,
    required this.child,
    this.cursorWhenEnabled = SystemMouseCursors.click,
    this.cursorWhenDisabled = SystemMouseCursors.forbidden,
    this.onActivate,
    this.onArrowDown,
    this.onFocusChanged,
    this.visualEffects,
    super.key,
  });

  final HeadlessPressableController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final bool enabled;
  final Widget child;

  final MouseCursor cursorWhenEnabled;
  final MouseCursor cursorWhenDisabled;

  final VoidCallback? onActivate;
  final VoidCallback? onArrowDown;
  final ValueChanged<bool>? onFocusChanged;
  final HeadlessPressableVisualEffectsController? visualEffects;

  @override
  Widget build(BuildContext context) {
    controller.setDisabled(!enabled);

    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      canRequestFocus: enabled,
      skipTraversal: !enabled,
      onFocusChange: (focused) {
        controller.handleFocusChange(focused);
        visualEffects?.focusChanged(focused);
        onFocusChanged?.call(focused);
      },
      onKeyEvent: (node, event) {
        if (onActivate == null) return KeyEventResult.ignored;
        return handlePressableKeyEvent(
          controller: controller,
          event: event,
          onActivate: onActivate!,
          onArrowDown: onArrowDown,
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          controller.handleMouseEnter();
          visualEffects?.hoverChanged(true);
        },
        onExit: (_) {
          controller.handleMouseExit();
          visualEffects?.hoverChanged(false);
        },
        cursor: enabled ? cursorWhenEnabled : cursorWhenDisabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            controller.handleTapDown();
            visualEffects?.pointerDown(
              localPosition: details.localPosition,
              globalPosition: details.globalPosition,
            );
          },
          onTapUp: (details) {
            visualEffects?.pointerUp(
              localPosition: details.localPosition,
              globalPosition: details.globalPosition,
            );
            controller.handleTapUp(onActivate: onActivate);
          },
          onTapCancel: () {
            controller.handleTapCancel();
            visualEffects?.pointerCancel();
          },
          child: child,
        ),
      ),
    );
  }
}

