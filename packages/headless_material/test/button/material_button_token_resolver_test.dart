import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('MaterialButtonTokenResolver', () {
    late MaterialButtonTokenResolver resolver;

    setUp(() {
      resolver = const MaterialButtonTokenResolver();
    });

    testWidgets('resolves tokens for filled variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
              );

              expect(tokens.backgroundColor, isNot(Colors.transparent));
              expect(tokens.borderColor, Colors.transparent);
              expect(tokens.padding, isNotNull);
              expect(tokens.borderRadius, isNotNull);
              expect(tokens.minSize, const Size(64, 40));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for outlined variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.outlined),
                states: {},
              );

              expect(tokens.backgroundColor, Colors.transparent);
              expect(tokens.borderColor, isNot(Colors.transparent));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for tonal variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final scheme = Theme.of(context).colorScheme;
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.tonal),
                states: {},
              );

              expect(tokens.backgroundColor, scheme.secondaryContainer);
              expect(tokens.foregroundColor, scheme.onSecondaryContainer);
              expect(tokens.borderColor, Colors.transparent);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for text variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final scheme = Theme.of(context).colorScheme;
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.text),
                states: {},
              );

              expect(tokens.foregroundColor, scheme.primary);
              expect(tokens.backgroundColor, Colors.transparent);
              expect(tokens.borderColor, Colors.transparent);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies disabled state modifiers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
              );

              final disabledTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {WidgetState.disabled},
              );

              // Disabled should have reduced opacity colors
              expect(
                disabledTokens.foregroundColor.a,
                lessThan(normalTokens.foregroundColor.a),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies pressed state modifiers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
              );

              final pressedTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {WidgetState.pressed},
              );

              // Pressed should modify background
              expect(pressedTokens.backgroundColor,
                  isNot(normalTokens.backgroundColor));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves different sizes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final smallTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.small),
                states: {},
              );

              final largeTokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.large),
                states: {},
              );

              // Large should have bigger text and padding
              final smallPadding = smallTokens.padding as EdgeInsets;
              final largePadding = largeTokens.padding as EdgeInsets;

              expect(largePadding.horizontal,
                  greaterThan(smallPadding.horizontal));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('material overrides win over contract overrides',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(size: RButtonSize.medium),
                states: {},
                overrides: RenderOverrides({
                  RButtonOverrides: const RButtonOverrides.tokens(
                    padding: EdgeInsets.all(1),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  MaterialButtonOverrides: const MaterialButtonOverrides(
                    density: MaterialComponentDensity.comfortable,
                    cornerStyle: MaterialCornerStyle.pill,
                  ),
                }),
              );

              expect(
                tokens.padding,
                const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              );
              expect(
                tokens.borderRadius,
                const BorderRadius.all(Radius.circular(999)),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies per-instance overrides (priority 1)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final overrideColor = Colors.red;
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(variant: RButtonVariant.filled),
                states: {},
                overrides: RenderOverrides({
                  RButtonOverrides: RButtonOverrides.tokens(
                    backgroundColor: overrideColor,
                  ),
                }),
              );

              // Override should win
              expect(tokens.backgroundColor, overrideColor);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('respects constraints for minSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RButtonSpec(),
                states: {},
                constraints: const BoxConstraints(minWidth: 100, minHeight: 60),
              );

              expect(tokens.minSize, const Size(100, 60));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('deterministic: same inputs produce same outputs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spec = const RButtonSpec(variant: RButtonVariant.filled);
              final states = {WidgetState.hovered};

              final tokens1 = resolver.resolve(
                context: context,
                spec: spec,
                states: states,
              );

              final tokens2 = resolver.resolve(
                context: context,
                spec: spec,
                states: states,
              );

              expect(tokens1, equals(tokens2));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
