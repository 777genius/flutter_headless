import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

import 'headless_pressable_controller.dart';
import 'logic/headless_pressable_key_intent.dart';

/// Adapter: Flutter [KeyEvent] -> pure [HeadlessPressableKeyIntent].
///
/// Keeps keyboard mapping out of core controller logic.
KeyEventResult handlePressableKeyEvent({
  required HeadlessPressableController controller,
  required KeyEvent event,
  required VoidCallback onActivate,
  VoidCallback? onArrowDown,
}) {
  final intent = _toIntent(event);
  if (intent == null) return KeyEventResult.ignored;

  final handled = controller.handleButtonLikeIntent(
    intent: intent,
    onActivate: onActivate,
    onArrowDown: onArrowDown,
  );

  return handled ? KeyEventResult.handled : KeyEventResult.ignored;
}

HeadlessPressableKeyIntent? _toIntent(KeyEvent event) {
  final key = event.logicalKey;

  if (key == LogicalKeyboardKey.space) {
    if (event is KeyDownEvent) return const HeadlessPressableSpaceDown();
    if (event is KeyUpEvent) return const HeadlessPressableSpaceUp();
  }

  if (key == LogicalKeyboardKey.enter) {
    if (event is KeyDownEvent) return const HeadlessPressableEnterDown();
    if (event is KeyUpEvent) return const HeadlessPressableEnterUp();
  }

  if (key == LogicalKeyboardKey.arrowDown) {
    if (event is KeyDownEvent) return const HeadlessPressableArrowDown();
  }

  return null;
}
