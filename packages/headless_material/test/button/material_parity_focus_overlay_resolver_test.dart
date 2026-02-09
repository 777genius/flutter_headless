import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';

void main() {
  group('MaterialParityFocusOverlayResolver', () {
    group('resolveOverlayColor', () {
      testWidgets('returns onPrimary overlay for filled variant',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.filled,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                );
                final expected = Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.1);
                expect(color, expected);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns onSecondaryContainer overlay for tonal variant',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.tonal,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                );
                final expected = Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withValues(alpha: 0.1);
                expect(color, expected);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns primary overlay for outlined variant',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.outlined,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                );
                final expected = Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1);
                expect(color, expected);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns primary overlay for text variant', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.text,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                );
                final expected = Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1);
                expect(color, expected);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null when not focused', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.filled,
                  state: const RButtonState(
                    isFocused: false,
                    showFocusHighlight: true,
                  ),
                );
                expect(color, isNull);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null when showFocusHighlight is false',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.filled,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: false,
                  ),
                );
                expect(color, isNull);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null when disabled even if focused', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final color =
                    MaterialParityFocusOverlayResolver.resolveOverlayColor(
                  context: context,
                  variant: RButtonVariant.filled,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                    isDisabled: true,
                  ),
                );
                expect(color, isNull);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });

    group('resolveFocusBorderSide', () {
      testWidgets('returns primary border for outlined variant when focused',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final side =
                    MaterialParityFocusOverlayResolver.resolveFocusBorderSide(
                  context: context,
                  variant: RButtonVariant.outlined,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                  ),
                );
                expect(side, isNotNull);
                expect(side!.color, Theme.of(context).colorScheme.primary);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null for non-outlined variants', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                for (final variant in [
                  RButtonVariant.filled,
                  RButtonVariant.tonal,
                  RButtonVariant.text,
                ]) {
                  final side =
                      MaterialParityFocusOverlayResolver.resolveFocusBorderSide(
                    context: context,
                    variant: variant,
                    state: const RButtonState(
                      isFocused: true,
                      showFocusHighlight: true,
                    ),
                  );
                  expect(side, isNull, reason: '$variant should return null');
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null when not focused', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final side =
                    MaterialParityFocusOverlayResolver.resolveFocusBorderSide(
                  context: context,
                  variant: RButtonVariant.outlined,
                  state: const RButtonState(
                    isFocused: false,
                    showFocusHighlight: true,
                  ),
                );
                expect(side, isNull);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });

      testWidgets('returns null when disabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final side =
                    MaterialParityFocusOverlayResolver.resolveFocusBorderSide(
                  context: context,
                  variant: RButtonVariant.outlined,
                  state: const RButtonState(
                    isFocused: true,
                    showFocusHighlight: true,
                    isDisabled: true,
                  ),
                );
                expect(side, isNull);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
    });
  });
}
