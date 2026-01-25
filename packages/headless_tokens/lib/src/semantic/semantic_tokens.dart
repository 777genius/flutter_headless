import 'package:meta/meta.dart';

import '../raw/raw_tokens.dart';
import 'surface.dart';
import 'text.dart';
import 'action.dart';
import 'border.dart';
import 'status.dart';
import 'dimension.dart';
import 'motion.dart';

export 'surface.dart';
export 'text.dart';
export 'action.dart';
export 'border.dart';
export 'status.dart';
export 'dimension.dart';
export 'motion.dart';

/// Base interface for semantic tokens (OCP extension point).
///
/// Allows defining custom tokens without modifying core.
/// See `docs/V1_DECISIONS.md` → "Extension mechanism (OCP compliance)".
///
/// Example:
/// ```dart
/// class BrandAccent extends SemanticToken<int> {
///   @override
///   String get name => 'brand.accent';
///
///   @override
///   int resolve(RawTokens tokens) => 0xFF6200EE;
/// }
/// ```
abstract class SemanticToken<T> {
  /// Unique token name in namespace (e.g., "global.color.semantic.action.primaryBg")
  String get name;

  /// Resolves the token value from raw tokens.
  T resolve(RawTokens tokens);
}

/// Global semantic primitives container.
///
/// This is the minimal whitelist of semantic tokens that form the
/// stable API contract. Component-specific tokens should use
/// `components.*` namespace instead of expanding this list.
///
/// See `docs/V1_DECISIONS.md` → "Semantic tokens v1: W3C-first + Hybrid".
@immutable
final class SemanticTokens {
  const SemanticTokens();

  /// Surface colors (canvas, base, raised, overlay)
  SurfaceColors get surface => const SurfaceColors();

  /// Text colors (primary, secondary, disabled, inverse)
  TextColors get text => const TextColors();

  /// Action colors (primaryBg, primaryFg)
  ActionColors get action => const ActionColors();

  /// Border colors (subtle, default, focus)
  BorderColors get border => const BorderColors();

  /// Status colors (danger, success)
  StatusColors get status => const StatusColors();

  /// Semantic dimensions (tapTargetMin)
  SemanticDimensions get dimension => const SemanticDimensions();

  /// Motion durations (fast, normal)
  MotionDurations get motion => const MotionDurations();
}
