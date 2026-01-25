import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoButtonRenderer', () {
    late CupertinoButtonRenderer renderer;

    setUp(() {
      renderer = const CupertinoButtonRenderer();
    });

    testWidgets('renders button with resolved tokens', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.primary),
                  state: const RButtonState(),
                  content: const Text('Tap me'),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.white,
                    backgroundColor: CupertinoColors.activeBlue,
                    borderColor: CupertinoColors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Tap me'), findsOneWidget);
      // There may be multiple DecoratedBox widgets (from CupertinoApp and our renderer)
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets('renders icon when provided in slots', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Save'),
                  leadingIcon: const Icon(CupertinoIcons.floppy_disk),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.activeBlue,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.floppy_disk), findsOneWidget);
    });

    testWidgets('uses AnimatedOpacity for pressed state (iOS style)',
        (tester) async {
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
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.activeBlue,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Find AnimatedOpacity and verify it has reduced opacity for pressed state
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      expect(animatedOpacityFinder, findsOneWidget);

      final animatedOpacity =
          tester.widget<AnimatedOpacity>(animatedOpacityFinder);
      // iOS uses 0.4 opacity for pressed state
      expect(animatedOpacity.opacity, 0.4);
    });

    testWidgets('respects disabled state for rendering', (tester) async {
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
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.inactiveGray,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify button renders with disabled state applied
      expect(find.text('Disabled'), findsOneWidget);

      // Disabled state is applied via Opacity wrapper
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.38);
    });

    testWidgets('enforces minimum size from tokens', (tester) async {
      const minSize = Size(100, 60);

      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('X'),
                  resolvedTokens: RButtonResolvedTokens(
                    textStyle: const TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.activeBlue,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.transparent,
                    padding: const EdgeInsets.all(8),
                    minSize: minSize,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
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

    testWidgets('renders border when borderColor is not transparent',
        (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.secondary),
                  state: const RButtonState(),
                  content: const Text('Outlined'),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.activeBlue,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.activeBlue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Outlined'), findsOneWidget);

      // Verify at least one DecoratedBox has border
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasBorder = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is BoxDecoration) {
          return decoration.border != null;
        }
        return false;
      });
      expect(hasBorder, isTrue);
    });

    testWidgets('shows thicker border when focused', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              return renderer.render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(variant: RButtonVariant.secondary),
                  state: const RButtonState(isFocused: true),
                  content: const Text('Focused'),
                  resolvedTokens: const RButtonResolvedTokens(
                    textStyle: TextStyle(fontSize: 17),
                    foregroundColor: CupertinoColors.activeBlue,
                    backgroundColor: CupertinoColors.transparent,
                    borderColor: CupertinoColors.activeBlue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minSize: Size(44, 44),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    disabledOpacity: 0.38,
                    pressOverlayColor: CupertinoColors.transparent,
                    pressOpacity: 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify at least one DecoratedBox has thicker border when focused
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final hasThickBorder = decoratedBoxes.any((box) {
        final decoration = box.decoration;
        if (decoration is BoxDecoration && decoration.border is Border) {
          final border = decoration.border as Border;
          return border.top.width == 2;
        }
        return false;
      });
      expect(hasThickBorder, isTrue);
    });

    group('no double-invoke contract', () {
      testWidgets('renderer has no tap handlers (single activation source)',
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
                    content: const Text('Test'),
                    resolvedTokens: const RButtonResolvedTokens(
                      textStyle: TextStyle(fontSize: 17),
                      foregroundColor: CupertinoColors.activeBlue,
                      backgroundColor: CupertinoColors.transparent,
                      borderColor: CupertinoColors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minSize: Size(44, 44),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      disabledOpacity: 0.38,
                      pressOverlayColor: CupertinoColors.transparent,
                      pressOpacity: 0.4,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // Cupertino renderer uses DecoratedBox + Padding, no GestureDetector
        expect(find.byType(GestureDetector), findsNothing);
      });

      // Note: In v1, button renderers receive no activation callbacks at all.
      // The invariant is enforced by the "no tap handlers" test above.
    });

    buttonRendererSingleActivationSourceConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
      createDefaultTokens: () => const RButtonResolvedTokens(
        textStyle: TextStyle(fontSize: 17),
        foregroundColor: CupertinoColors.activeBlue,
        backgroundColor: CupertinoColors.transparent,
        borderColor: CupertinoColors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minSize: Size(44, 44),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        disabledOpacity: 0.38,
        pressOverlayColor: CupertinoColors.transparent,
        pressOpacity: 0.4,
      ),
      assertSingleActivationSource: (tester) {
        final scope = find.byType(ConstrainedBox).first;
        final gestureDetectors =
            find.descendant(of: scope, matching: find.byType(GestureDetector));

        for (final e in gestureDetectors.evaluate()) {
          final w = e.widget;
          if (w is! GestureDetector) continue;
          expect(w.onTap, isNull);
          expect(w.onTapDown, isNull);
          expect(w.onTapUp, isNull);
        }
      },
    );

    buttonRendererMotionConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
      createTokensForDuration: (duration) => RButtonResolvedTokens(
        textStyle: const TextStyle(fontSize: 17),
        foregroundColor: CupertinoColors.activeBlue,
        backgroundColor: CupertinoColors.transparent,
        borderColor: CupertinoColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minSize: const Size(44, 44),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        disabledOpacity: 0.38,
        pressOverlayColor: CupertinoColors.transparent,
        pressOpacity: 0.4,
        motion: RButtonMotionTokens(stateChangeDuration: duration),
      ),
      assertDurationUsed: (tester, expectedDuration) {
        final animated = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity).first,
        );
        expect(animated.duration, expectedDuration);
      },
    );

    buttonRendererMustNotRequireThemeProviderConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
    );
  });
}
