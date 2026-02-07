import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';

import 'helpers/parity_test_harness.dart';

/// Golden parity tests: [CupertinoFlutterParityButtonRenderer] vs [CupertinoButton].
///
/// Strategy:
/// - Headless side: force visual state via [RButtonState] (pressed/focused/disabled).
/// - Native side: use actual widget behavior (press via held pointer, focus via focusNode).
void main() {
  group('Golden parity: CupertinoFlutterParityButtonRenderer', () {
    const renderer = CupertinoFlutterParityButtonRenderer();

    Widget buildRendererButton(
      BuildContext context, {
      required RButtonVariant variant,
      required RButtonSize size,
      required RButtonState state,
    }) {
      return renderer.render(
        RButtonRenderRequest(
          context: context,
          spec: RButtonSpec(variant: variant, size: size),
          state: state,
          content: const Text('Label'),
          resolvedTokens: null,
        ),
      );
    }

    Future<void> pumpGolden({
      required WidgetTester tester,
      required RButtonVariant variant,
      required RButtonSize size,
      required RButtonState rendererState,
      required bool nativeEnabled,
      required String goldenName,
      bool holdNativePressed = false,
      bool requestNativeFocus = false,
    }) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildRendererParityHarness(
          rendererBuilder: (context) => Center(
            child: buildRendererButton(
              context,
              variant: variant,
              size: size,
              state: rendererState,
            ),
          ),
          nativeButton: Center(
            child: buildNativeCupertinoButton(
              key: const Key('native'),
              variant: variant,
              size: size,
              enabled: nativeEnabled,
              focusNode: focusNode,
              absorbPointer: !holdNativePressed,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      if (requestNativeFocus) {
        // CupertinoButton shows focus highlight based on FocusableActionDetector's
        // onShowFocusHighlight, which depends on focus highlight mode.
        // In widget tests we force "traditional" highlight by sending a key event.
        await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        focusNode.requestFocus();
        await tester.pumpAndSettle();
      }

      if (holdNativePressed) {
        final finder = find.byKey(const Key('native'));
        final gesture = await tester.startGesture(tester.getCenter(finder));
        addTearDown(gesture.removePointer);
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(CupertinoPageScaffold),
        matchesGoldenFile('goldens/$goldenName.png'),
      );
    }

    testWidgets('filled — pressed (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.filled,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(isPressed: true),
        goldenName: 'renderer_filled_pressed',
        holdNativePressed: true,
      );
    });

    testWidgets('filled — focused (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.filled,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(
          isFocused: true,
          showFocusHighlight: true,
        ),
        goldenName: 'renderer_filled_focused',
        requestNativeFocus: true,
      );
    });

    testWidgets('filled — disabled (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.filled,
        size: RButtonSize.medium,
        nativeEnabled: false,
        rendererState: const RButtonState(isDisabled: true),
        goldenName: 'renderer_filled_disabled',
      );
    });

    testWidgets('tonal — pressed (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.tonal,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(isPressed: true),
        goldenName: 'renderer_tonal_pressed',
        holdNativePressed: true,
      );
    });

    testWidgets('tonal — focused (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.tonal,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(
          isFocused: true,
          showFocusHighlight: true,
        ),
        goldenName: 'renderer_tonal_focused',
        requestNativeFocus: true,
      );
    });

    testWidgets('tonal — disabled (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.tonal,
        size: RButtonSize.medium,
        nativeEnabled: false,
        rendererState: const RButtonState(isDisabled: true),
        goldenName: 'renderer_tonal_disabled',
      );
    });

    testWidgets('text — pressed (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.text,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(isPressed: true),
        goldenName: 'renderer_text_pressed',
        holdNativePressed: true,
      );
    });

    testWidgets('text — focused (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.text,
        size: RButtonSize.medium,
        nativeEnabled: true,
        rendererState: const RButtonState(
          isFocused: true,
          showFocusHighlight: true,
        ),
        goldenName: 'renderer_text_focused',
        requestNativeFocus: true,
      );
    });

    testWidgets('text — disabled (medium)', (tester) async {
      await pumpGolden(
        tester: tester,
        variant: RButtonVariant.text,
        size: RButtonSize.medium,
        nativeEnabled: false,
        rendererState: const RButtonState(isDisabled: true),
        goldenName: 'renderer_text_disabled',
      );
    });
  });
}
