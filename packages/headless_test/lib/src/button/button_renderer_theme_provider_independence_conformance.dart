import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Conformance: preset renderers MUST NOT require [HeadlessThemeProvider].
///
/// Presets are allowed to use:
/// - `HeadlessThemeProvider.of(context)` (nullable) for optional capabilities
/// but MUST NOT call:
/// - `HeadlessThemeProvider.themeOf(context)` inside renderer code paths
///
/// Rationale: conformance suites often render preset renderers in isolation.
void buttonRendererMustNotRequireThemeProviderConformance({
  required String presetName,
  required RButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
}) {
  group('$presetName button renderer theme-provider independence', () {
    testWidgets('does not throw without HeadlessThemeProvider', (tester) async {
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
                ),
              );
            },
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
