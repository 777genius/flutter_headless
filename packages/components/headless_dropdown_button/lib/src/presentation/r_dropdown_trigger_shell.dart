import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

final class RDropdownTriggerShell extends StatelessWidget {
  const RDropdownTriggerShell({
    super.key,
    required this.triggerKey,
    required this.isDisabled,
    required this.isExpanded,
    required this.semanticLabel,
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onToggleMenu,
    required this.onArrowDown,
    required this.onEscape,
    required this.onFocusLost,
    required this.visualEffects,
    required this.child,
  });

  final GlobalKey triggerKey;
  final bool isDisabled;
  final bool isExpanded;
  final String? semanticLabel;
  final HeadlessPressableController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onToggleMenu;
  final VoidCallback onArrowDown;
  final VoidCallback onEscape;
  final VoidCallback onFocusLost;
  final HeadlessPressableVisualEffectsController visualEffects;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (!isExpanded ||
            event is! KeyDownEvent ||
            event.logicalKey != LogicalKeyboardKey.escape) {
          return KeyEventResult.ignored;
        }
        onEscape();
        return KeyEventResult.handled;
      },
      child: Semantics(
        button: true,
        enabled: !isDisabled,
        expanded: isExpanded,
        label: semanticLabel,
        onTap: isDisabled ? null : onToggleMenu,
        child: HeadlessPressableRegion(
          key: triggerKey,
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: !isDisabled,
          cursorWhenEnabled: SystemMouseCursors.click,
          cursorWhenDisabled: SystemMouseCursors.forbidden,
          onActivate: onToggleMenu,
          onArrowDown: onArrowDown,
          onFocusChanged: (focused) {
            if (!focused) onFocusLost();
          },
          visualEffects: visualEffects,
          child: child,
        ),
      ),
    );
  }
}
