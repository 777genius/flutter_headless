import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_test/headless_test.dart';

void main() {
  group('MaterialFlutterParityButtonRenderer', () {
    late MaterialFlutterParityButtonRenderer renderer;

    setUp(() {
      renderer = const MaterialFlutterParityButtonRenderer();
    });

    testWidgets('throws StateError when useMaterial3 is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          home: Builder(
            builder: (context) {
              return renderer.render(
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

      final e = tester.takeException();
      expect(e, isA<StateError>());
      expect(
        e.toString(),
        contains('requires Material 3'),
      );
    });

    testWidgets('filled variant renders FilledButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Filled'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.text('Filled'), findsOneWidget);
    });

    testWidgets('tonal variant renders FilledButton.tonal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.tonal),
                  state: const RButtonState(),
                  content: const Text('Tonal'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);
      expect(find.text('Tonal'), findsOneWidget);
    });

    testWidgets('outlined variant renders OutlinedButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.outlined),
                  state: const RButtonState(),
                  content: const Text('Outlined'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.text('Outlined'), findsOneWidget);
    });

    testWidgets('text variant renders TextButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.text),
                  state: const RButtonState(),
                  content: const Text('Text'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('output is wrapped in ExcludeSemantics + AbsorbPointer',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Inert'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(ExcludeSemantics), findsAtLeastNWidgets(1));
      expect(
        find.byWidgetPredicate((w) => w is AbsorbPointer && w.absorbing),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('disabled state propagates to Flutter button',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(isDisabled: true),
                  content: const Text('Disabled'),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(filledButton.onPressed, isNull);
    });

    testWidgets('enabled state gives no-op onPressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Enabled'),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(filledButton.onPressed, isNotNull);
    });

    testWidgets('pressed state propagates to statesController',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(isPressed: true),
                  content: const Text('Pressed'),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(
        filledButton.statesController!.value,
        contains(WidgetState.pressed),
      );
    });

    testWidgets('hovered state propagates to statesController',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(isHovered: true),
                  content: const Text('Hovered'),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(
        filledButton.statesController!.value,
        contains(WidgetState.hovered),
      );
    });

    testWidgets('focused state propagates to statesController',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(isFocused: true),
                  content: const Text('Focused'),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(
        filledButton.statesController!.value,
        contains(WidgetState.focused),
      );
    });

    testWidgets('overrides backgroundColor applies to ButtonStyle',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Styled'),
                  overrides: RenderOverrides.only(
                    const RButtonOverrides(backgroundColor: Color(0xFFFF0000)),
                  ),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final bgColor = filledButton.style?.backgroundColor?.resolve({});
      expect(bgColor, const Color(0xFFFF0000));
    });

    testWidgets('overrides borderColor applies to OutlinedButton side',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.outlined),
                  state: const RButtonState(),
                  content: const Text('Bordered'),
                  overrides: RenderOverrides.only(
                    const RButtonOverrides(borderColor: Color(0xFF00FF00)),
                  ),
                ),
              );
            },
          ),
        ),
      );

      final outlinedButton = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      final side = outlinedButton.style?.side?.resolve({});
      expect(side?.color, const Color(0xFF00FF00));
    });

    testWidgets('overrides borderRadius applies RoundedRectangleBorder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Rounded'),
                  overrides: RenderOverrides.only(
                    RButtonOverrides(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final shape = filledButton.style?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final rrb = shape as RoundedRectangleBorder;
      expect(rrb.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('works with resolvedTokens == null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('No tokens'),
                  resolvedTokens: null,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('No tokens'), findsOneWidget);
    });

    group('M3 Expressive size mapping', () {
      testWidgets('small size applies 36dp minimum height', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RButtonRenderRequest(
                    context: context,
                    spec: const RButtonSpec(
                      variant: RButtonVariant.filled,
                      size: RButtonSize.small,
                    ),
                    state: const RButtonState(),
                    content: const Text('S'),
                  ),
                );
              },
            ),
          ),
        );

        final button = tester.widget<FilledButton>(
          find.byType(FilledButton),
        );
        final minSize = button.style?.minimumSize?.resolve({});
        expect(minSize?.height, 36.0);
      });

      testWidgets('medium size applies 40dp minimum height', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RButtonRenderRequest(
                    context: context,
                    spec: const RButtonSpec(
                      variant: RButtonVariant.filled,
                      size: RButtonSize.medium,
                    ),
                    state: const RButtonState(),
                    content: const Text('M'),
                  ),
                );
              },
            ),
          ),
        );

        final button = tester.widget<FilledButton>(
          find.byType(FilledButton),
        );
        final minSize = button.style?.minimumSize?.resolve({});
        expect(minSize?.height, 40.0);
      });

      testWidgets('large size applies 48dp minimum height', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RButtonRenderRequest(
                    context: context,
                    spec: const RButtonSpec(
                      variant: RButtonVariant.filled,
                      size: RButtonSize.large,
                    ),
                    state: const RButtonState(),
                    content: const Text('L'),
                  ),
                );
              },
            ),
          ),
        );

        final button = tester.widget<FilledButton>(
          find.byType(FilledButton),
        );
        final minSize = button.style?.minimumSize?.resolve({});
        expect(minSize?.height, 48.0);
      });

      testWidgets('small has tighter padding than large', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Row(
                  children: [
                    renderer.render(
                      RButtonRenderRequest(
                        context: context,
                        spec: const RButtonSpec(
                          variant: RButtonVariant.filled,
                          size: RButtonSize.small,
                        ),
                        state: const RButtonState(),
                        content: const Text('S'),
                      ),
                    ),
                    renderer.render(
                      RButtonRenderRequest(
                        context: context,
                        spec: const RButtonSpec(
                          variant: RButtonVariant.filled,
                          size: RButtonSize.large,
                        ),
                        state: const RButtonState(),
                        content: const Text('L'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        final buttons = tester.widgetList<FilledButton>(
          find.byType(FilledButton),
        ).toList();
        final smallPad = buttons[0].style?.padding?.resolve({}) as EdgeInsets;
        final largePad = buttons[1].style?.padding?.resolve({}) as EdgeInsets;
        expect(largePad.horizontal, greaterThan(smallPad.horizontal));
      });

      testWidgets('size works with all variants', (tester) async {
        for (final variant in RButtonVariant.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  return renderer.render(
                    RButtonRenderRequest(
                      context: context,
                      spec: RButtonSpec(
                        variant: variant,
                        size: RButtonSize.large,
                      ),
                      state: const RButtonState(),
                      content: const Text('Test'),
                    ),
                  );
                },
              ),
            ),
          );

          expect(find.text('Test'), findsOneWidget);
        }
      });
    });

    buttonRendererSingleActivationSourceConformanceV2(
      presetName: 'Material parity',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
    );
  });
}
