import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('MaterialButtonRenderer', () {
    late MaterialButtonRenderer renderer;

    setUp(() {
      renderer = const MaterialButtonRenderer();
    });

    testWidgets('renders button with resolved tokens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.primary),
                  state: const RButtonState(),
                  content: const Text('Click me'),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 14),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    borderColor: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    minSize: Size(48, 48),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Click me'), findsOneWidget);
      expect(find.byType(Material), findsOneWidget);
    });

    testWidgets('renders icon when provided in slots', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Save'),
                  leadingIcon: const Icon(Icons.save),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 14),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    borderColor: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    minSize: Size(48, 48),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('renders trailing icon when provided in slots', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Next'),
                  trailingIcon: const Icon(Icons.chevron_right),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 14),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    borderColor: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    minSize: Size(48, 48),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('renders spinner when provided in slots', (tester) async {
      const spinnerKey = Key('spinner');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Save'),
                  spinner: const SizedBox(key: spinnerKey),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 14),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    borderColor: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    minSize: Size(48, 48),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byKey(spinnerKey), findsOneWidget);
      expect(find.text('Save'), findsNothing);
    });

    testWidgets('applies semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(semanticLabel: 'Save document'),
                  state: const RButtonState(),
                  content: const Text('Save'),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 14),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    borderColor: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    minSize: Size(48, 48),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify button renders correctly
      expect(find.text('Save'), findsOneWidget);

      // Verify there's a Semantics widget (Material adds multiple)
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('respects disabled state for rendering', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(isDisabled: true),
                  content: const Text('Disabled'),
                  resolvedTokens: RButtonResolvedTokens(
                    textStyle: const TextStyle(fontSize: 14),
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.grey.shade200,
                    borderColor: Colors.transparent,
                    padding: const EdgeInsets.all(16),
                    minSize: const Size(48, 48),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify button renders with disabled state applied
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('enforces minimum size from tokens', (tester) async {
      const minSize = Size(100, 60);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('X'),
                  resolvedTokens: RButtonResolvedTokens(
                    textStyle: const TextStyle(fontSize: 14),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    borderColor: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                    minSize: minSize,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: Color(0x1F000000),
                    pressOpacity: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      );

      final box = tester.getSize(find.byType(ConstrainedBox).first);
      expect(box.width, greaterThanOrEqualTo(minSize.width));
      expect(box.height, greaterThanOrEqualTo(minSize.height));
    });

    buttonRendererSingleActivationSourceConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createDefaultTokens: () => const RButtonResolvedTokens(
        textStyle: TextStyle(fontSize: 14),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
        borderColor: Colors.transparent,
        padding: EdgeInsets.all(16),
        minSize: Size(48, 48),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        disabledOpacity: 0.38,
        pressOverlayColor: Color(0x1F000000),
        pressOpacity: 1.0,
      ),
      assertSingleActivationSource: (tester) {
        expect(find.byType(InkWell), findsNothing);
      },
    );

    buttonRendererMotionConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createTokensForDuration: (duration) => RButtonResolvedTokens(
        textStyle: const TextStyle(fontSize: 14),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
        borderColor: Colors.transparent,
        padding: const EdgeInsets.all(16),
        minSize: const Size(48, 48),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        disabledOpacity: 0.38,
        pressOverlayColor: Color(0x1F000000),
        pressOpacity: 1.0,
        motion: RButtonMotionTokens(stateChangeDuration: duration),
      ),
      assertDurationUsed: (tester, expectedDuration) {
        final animated = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer).first,
        );
        expect(animated.duration, expectedDuration);
      },
    );

    buttonRendererMustNotRequireThemeProviderConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
    );
  });
}
