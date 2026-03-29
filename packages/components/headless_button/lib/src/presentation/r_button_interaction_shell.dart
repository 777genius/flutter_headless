import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

class RButtonInteractionShell extends StatelessWidget {
  const RButtonInteractionShell({
    super.key,
    required this.context,
    required this.isDisabled,
    required this.semanticLabel,
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onActivate,
    required this.visualEffects,
    required this.child,
  });

  final BuildContext context;
  final bool isDisabled;
  final String? semanticLabel;
  final HeadlessPressableController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onActivate;
  final HeadlessPressableVisualEffectsController visualEffects;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tapTargetSize = _resolveTapTargetSize(this.context);
    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: semanticLabel,
      onTap: isDisabled ? null : onActivate,
      child: HeadlessPressableRegion(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: !isDisabled,
        cursorWhenEnabled: SystemMouseCursors.click,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        onActivate: onActivate,
        visualEffects: visualEffects,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: tapTargetSize.width,
            minHeight: tapTargetSize.height,
          ),
          child: Center(widthFactor: 1.0, heightFactor: 1.0, child: child),
        ),
      ),
    );
  }
}

Size _resolveTapTargetSize(BuildContext context) {
  final policy =
      HeadlessThemeProvider.of(context)?.capability<HeadlessTapTargetPolicy>();
  if (policy != null) {
    return policy.minTapTargetSize(
      context: context,
      component: HeadlessTapTargetComponent.button,
    );
  }
  return WcagConstants.kMinTouchTargetSize;
}
