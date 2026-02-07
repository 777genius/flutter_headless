import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'package:headless_foundation/src/interaction/logic/headless_pressable_key_intent.dart';

void main() {
  group('HeadlessPressableController keyboard policy', () {
    test('disabled: ignores all intents', () {
      final c = HeadlessPressableController(isDisabled: true);

      var activated = 0;
      final handled = c.handleButtonLikeIntent(
        intent: const HeadlessPressableEnterDown(),
        onActivate: () => activated++,
      );

      expect(handled, isFalse);
      expect(activated, 0);
    });

    test('Space: down sets pressed; up activates and clears pressed', () {
      final c = HeadlessPressableController();

      var activated = 0;
      expect(c.state.isPressed, isFalse);

      final downHandled = c.handleButtonLikeIntent(
        intent: const HeadlessPressableSpaceDown(),
        onActivate: () => activated++,
      );
      expect(downHandled, isTrue);
      expect(c.state.isPressed, isTrue);
      expect(activated, 0);

      final upHandled = c.handleButtonLikeIntent(
        intent: const HeadlessPressableSpaceUp(),
        onActivate: () => activated++,
      );
      expect(upHandled, isTrue);
      expect(c.state.isPressed, isFalse);
      expect(activated, 1);
    });

    test('Space: repeat down is ignored (anti-repeat)', () {
      final c = HeadlessPressableController();

      var activated = 0;
      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableSpaceDown(),
          onActivate: () => activated++,
        ),
        isTrue,
      );

      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableSpaceDown(),
          onActivate: () => activated++,
        ),
        isFalse,
      );
      expect(c.state.isPressed, isTrue);
      expect(activated, 0);
    });

    test('Enter: down activates once; repeat down ignored; up clears guard',
        () {
      final c = HeadlessPressableController();

      var activated = 0;
      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableEnterDown(),
          onActivate: () => activated++,
        ),
        isTrue,
      );
      expect(activated, 1);

      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableEnterDown(),
          onActivate: () => activated++,
        ),
        isFalse,
      );
      expect(activated, 1);

      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableEnterUp(),
          onActivate: () => activated++,
        ),
        isTrue,
      );

      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableEnterDown(),
          onActivate: () => activated++,
        ),
        isTrue,
      );
      expect(activated, 2);
    });

    test('ArrowDown: handled only when callback provided', () {
      final c = HeadlessPressableController();

      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableArrowDown(),
          onActivate: () {},
        ),
        isFalse,
      );

      var opened = 0;
      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableArrowDown(),
          onActivate: () {},
          onArrowDown: () => opened++,
        ),
        isTrue,
      );
      expect(opened, 1);
    });

    test('focus loss resets keyboard guards and pressed state', () {
      final c = HeadlessPressableController();

      var activated = 0;
      c.handleFocusChange(true);
      c.handleButtonLikeIntent(
        intent: const HeadlessPressableSpaceDown(),
        onActivate: () => activated++,
      );
      expect(c.state.isPressed, isTrue);

      c.handleFocusChange(false);
      expect(c.state.isPressed, isFalse);

      // Space up after reset should be ignored (no stray activation)
      expect(
        c.handleButtonLikeIntent(
          intent: const HeadlessPressableSpaceUp(),
          onActivate: () => activated++,
        ),
        isFalse,
      );
      expect(activated, 0);
    });
  });
}
