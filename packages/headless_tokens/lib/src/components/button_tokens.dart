import 'package:meta/meta.dart';

import '../semantic/semantic_tokens.dart';

/// Button component tokens.
///
/// Component-specific tokens that reference global semantic primitives.
/// This keeps the global layer minimal while providing precise control
/// for renderers.
///
/// See `docs/V1_DECISIONS.md` → "Component tokens v1: Button".
@immutable
final class ButtonTokens {
  const ButtonTokens({
    SemanticTokens? semanticTokens,
  }) : _semantic = semanticTokens ?? const SemanticTokens();

  final SemanticTokens _semantic;

  // === Dimensions ===

  /// Minimum tap target (WCAG 2.2 compliance)
  double get minTapTarget => _semantic.dimension.tapTargetMin;

  // === Focus ===

  /// Focus ring color
  int get focusRingColor => _semantic.border.focus;

  // === Default variant ===

  /// Default button background
  int get bgDefault => _semantic.surface.base;

  /// Default button foreground
  int get fgDefault => _semantic.text.primary;

  // === Primary variant ===

  /// Primary button background
  int get bgPrimary => _semantic.action.primaryBg;

  /// Primary button foreground
  int get fgPrimary => _semantic.action.primaryFg;

  // === Disabled state ===

  /// Disabled button foreground
  int get fgDisabled => _semantic.text.disabled;
}
