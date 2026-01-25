import 'package:headless_tokens/headless_tokens.dart';
import 'package:test/test.dart';

void main() {
  group('RawTokens', () {
    test('spacing tokens are defined', () {
      const tokens = RawTokens();
      expect(tokens.spacing.s0, 0);
      expect(tokens.spacing.s8, 8);
      expect(tokens.spacing.s24, 24);
    });

    test('radii tokens are defined', () {
      const tokens = RawTokens();
      expect(tokens.radii.none, 0);
      expect(tokens.radii.sm, 6);
      expect(tokens.radii.lg, 16);
    });

    test('duration tokens are defined', () {
      const tokens = RawTokens();
      expect(tokens.durations.fast, const Duration(milliseconds: 150));
      expect(tokens.durations.normal, const Duration(milliseconds: 300));
    });
  });

  group('SemanticTokens', () {
    test('surface colors are defined', () {
      const tokens = SemanticTokens();
      expect(tokens.surface.canvas, isNonZero);
      expect(tokens.surface.base, isNonZero);
    });

    test('text colors are defined', () {
      const tokens = SemanticTokens();
      expect(tokens.text.primary, isNonZero);
      expect(tokens.text.disabled, isNonZero);
    });

    test('action colors are defined', () {
      const tokens = SemanticTokens();
      expect(tokens.action.primaryBg, isNonZero);
      expect(tokens.action.primaryFg, isNonZero);
    });

    test('dimension tokens are defined', () {
      const tokens = SemanticTokens();
      expect(tokens.dimension.tapTargetMin, 24.0);
    });

    test('motion tokens are defined', () {
      const tokens = SemanticTokens();
      expect(tokens.motion.fast, const Duration(milliseconds: 150));
    });
  });

  group('ButtonTokens', () {
    test('references semantic tokens correctly', () {
      const semantic = SemanticTokens();
      const button = ButtonTokens();

      expect(button.minTapTarget, semantic.dimension.tapTargetMin);
      expect(button.bgPrimary, semantic.action.primaryBg);
      expect(button.fgDisabled, semantic.text.disabled);
    });
  });

  group('ComponentTokens', () {
    test('provides button tokens', () {
      const components = ComponentTokens();
      expect(components.button, isA<ButtonTokens>());
    });
  });
}
