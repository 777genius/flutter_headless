import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('MaterialDropdownTokenResolver', () {
    late MaterialDropdownTokenResolver resolver;

    setUp(() {
      resolver = const MaterialDropdownTokenResolver();
    });

    testWidgets('resolves tokens for outlined variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(variant: RDropdownVariant.outlined),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              expect(tokens.trigger.backgroundColor, Colors.transparent);
              expect(tokens.trigger.borderColor, isNot(Colors.transparent));
              expect(tokens.menu.elevation, 3.0);
              expect(tokens.item.minHeight, 48.0);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves tokens for filled variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(variant: RDropdownVariant.filled),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              expect(tokens.trigger.backgroundColor, isNot(Colors.transparent));
              expect(tokens.trigger.borderColor, Colors.transparent);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('overlay phase affects trigger border (open state)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final closedTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(variant: RDropdownVariant.outlined),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final openTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(variant: RDropdownVariant.outlined),
                triggerStates: {},
                overlayPhase: ROverlayPhase.open,
              );

              // Open state should have primary border
              expect(openTokens.trigger.borderColor, isNot(closedTokens.trigger.borderColor));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies disabled state to trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final normalTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final disabledTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {WidgetState.disabled},
                overlayPhase: ROverlayPhase.closed,
              );

              // Disabled should have reduced opacity
              expect(
                disabledTokens.trigger.foregroundColor.a,
                lessThan(normalTokens.trigger.foregroundColor.a),
              );

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
                spec: const RDropdownButtonSpec(size: RDropdownSize.small),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final largeTokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(size: RDropdownSize.large),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
              );

              final smallPadding = smallTokens.trigger.padding as EdgeInsets;
              final largePadding = largeTokens.trigger.padding as EdgeInsets;

              expect(largePadding.horizontal, greaterThan(smallPadding.horizontal));

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('applies per-instance overrides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final overrideColor = Colors.red;
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
                overrides: RenderOverrides({
                  RDropdownOverrides: RDropdownOverrides.tokens(
                    triggerBackgroundColor: overrideColor,
                    menuMaxHeight: 500,
                  ),
                }),
              );

              expect(tokens.trigger.backgroundColor, overrideColor);
              expect(tokens.menu.maxHeight, 500);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('material overrides win over contract overrides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(size: RDropdownSize.medium),
                triggerStates: {},
                overlayPhase: ROverlayPhase.closed,
                overrides: RenderOverrides({
                  RDropdownOverrides: const RDropdownOverrides.tokens(
                    triggerPadding: EdgeInsets.all(1),
                    triggerBorderRadius: BorderRadius.all(Radius.circular(24)),
                    itemMinHeight: 100,
                  ),
                  MaterialDropdownOverrides: const MaterialDropdownOverrides(
                    density: MaterialComponentDensity.compact,
                    cornerStyle: MaterialCornerStyle.sharp,
                  ),
                }),
              );

              expect(
                tokens.trigger.padding,
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              );
              expect(
                tokens.trigger.borderRadius,
                const BorderRadius.all(Radius.circular(4)),
              );
              expect(tokens.item.minHeight, 40);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('resolves item tokens correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tokens = resolver.resolve(
                context: context,
                spec: const RDropdownButtonSpec(),
                triggerStates: {},
                overlayPhase: ROverlayPhase.open,
              );

              expect(tokens.item.foregroundColor, isNotNull);
              expect(tokens.item.backgroundColor, Colors.transparent);
              expect(tokens.item.highlightBackgroundColor, isNot(Colors.transparent));
              expect(tokens.item.selectedBackgroundColor, isNot(Colors.transparent));
              expect(tokens.item.disabledForegroundColor, isNotNull);
              expect(tokens.item.selectedMarkerColor, isNotNull);

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('deterministic: same inputs produce same outputs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spec = const RDropdownButtonSpec();
              const states = <WidgetState>{WidgetState.focused};
              const phase = ROverlayPhase.open;

              final tokens1 = resolver.resolve(
                context: context,
                spec: spec,
                triggerStates: states,
                overlayPhase: phase,
              );

              final tokens2 = resolver.resolve(
                context: context,
                spec: spec,
                triggerStates: states,
                overlayPhase: phase,
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
