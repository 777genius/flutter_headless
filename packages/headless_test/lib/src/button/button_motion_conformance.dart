import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

void buttonRendererMotionConformance({
  required String presetName,
  required RButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RButtonResolvedTokens Function(Duration duration)
      createTokensForDuration,
  required void Function(WidgetTester tester, Duration expectedDuration)
      assertDurationUsed,
}) {
  group('$presetName button motion conformance', () {
    testWidgets('stateChangeDuration is used by renderer', (tester) async {
      const duration = Duration(milliseconds: 321);

      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Test'),
                  resolvedTokens: createTokensForDuration(duration),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      assertDurationUsed(tester, duration);
    });
  });
}
