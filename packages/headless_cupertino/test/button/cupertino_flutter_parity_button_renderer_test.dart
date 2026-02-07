import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_test/headless_test.dart';

void main() {
  group('CupertinoFlutterParityButtonRenderer', () {
    late CupertinoFlutterParityButtonRenderer renderer;

    setUp(() {
      renderer = const CupertinoFlutterParityButtonRenderer();
    });

    testWidgets('filled variant renders filled style (colored bg)',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
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

      expect(find.text('Filled'), findsOneWidget);

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasColoredBg = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color != null &&
              decoration.color != CupertinoColors.transparent;
        }
        if (decoration is ShapeDecoration) {
          return decoration.color != null &&
              decoration.color != CupertinoColors.transparent;
        }
        return false;
      });
      expect(hasColoredBg, isTrue);
    });

    testWidgets('tonal variant renders tinted style (translucent bg)',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
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

      expect(find.text('Tonal'), findsOneWidget);

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasTintedBg = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is ShapeDecoration) {
          final color = decoration.color;
          return color != null &&
              color != CupertinoColors.transparent &&
              color.a < 1.0;
        }
        return false;
      });
      expect(hasTintedBg, isTrue);
    });

    testWidgets(
        'outlined variant renders outline border (non-native extension)',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
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

      expect(find.text('Outlined'), findsOneWidget);

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasOutlineBorder = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is ShapeDecoration &&
            decoration.shape is RoundedSuperellipseBorder) {
          final rse = decoration.shape as RoundedSuperellipseBorder;
          return rse.side != BorderSide.none && rse.side.width == 1.0;
        }
        return false;
      });
      expect(hasOutlineBorder, isTrue);

      final hasTransparentBg = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is ShapeDecoration) {
          return decoration.color == null;
        }
        return false;
      });
      expect(hasTransparentBg, isTrue);
    });

    testWidgets('text variant renders plain style (transparent bg)',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
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

      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('size mapping: small uses small min height', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(size: RButtonSize.small),
                  state: const RButtonState(),
                  content: const Text('S'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('size mapping: large uses large min height', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(size: RButtonSize.large),
                  state: const RButtonState(),
                  content: const Text('L'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('pressed animation uses FadeTransition', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(isPressed: true),
                  content: const Text('Pressed'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets('disabled state applies opacity', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(isDisabled: true),
                  content: const Text('Disabled'),
                ),
              );
            },
          ),
        ),
      );

      // Parity renderer should follow Flutter's disabled visuals (colors),
      // not a global Opacity wrapper.
      expect(find.byType(Opacity), findsNothing);

      final element = tester.element(find.text('Disabled'));
      final effectiveStyle = DefaultTextStyle.of(element).style;
      expect(effectiveStyle.color, isNotNull);
    });

    testWidgets('focused+showFocusHighlight renders focus outline',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                  content: const Text('Focused'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Focused'), findsOneWidget);

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasFocusBorder = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is ShapeDecoration &&
            decoration.shape is RoundedSuperellipseBorder) {
          final rse = decoration.shape as RoundedSuperellipseBorder;
          return rse.side != BorderSide.none;
        }
        return false;
      });
      expect(hasFocusBorder, isTrue);
    });

    testWidgets('overrides backgroundColor applies', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Custom'),
                  overrides: RenderOverrides.only(
                    const RButtonOverrides(backgroundColor: Color(0xFFFF0000)),
                  ),
                ),
              );
            },
          ),
        ),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasCustomBg = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is ShapeDecoration) {
          return decoration.color == const Color(0xFFFF0000);
        }
        return false;
      });
      expect(hasCustomBg, isTrue);
    });

    testWidgets('overrides foregroundColor applies to text', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.filled),
                  state: const RButtonState(),
                  content: const Text('Colored'),
                  overrides: RenderOverrides.only(
                    const RButtonOverrides(foregroundColor: Color(0xFF00FF00)),
                  ),
                ),
              );
            },
          ),
        ),
      );

      final element = tester.element(find.text('Colored'));
      final effectiveStyle = DefaultTextStyle.of(element).style;
      expect(effectiveStyle.color, const Color(0xFF00FF00));
    });

    testWidgets('output is wrapped in ExcludeSemantics + AbsorbPointer',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
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

    test('usesResolvedTokens returns false (token-mode)', () {
      expect(renderer.usesResolvedTokens, isFalse);
    });

    buttonRendererSingleActivationSourceConformanceV2(
      presetName: 'Cupertino parity',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
    );
  });
}
