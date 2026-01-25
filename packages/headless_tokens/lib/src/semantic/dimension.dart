import 'package:meta/meta.dart';

/// Dimension semantic tokens.
///
/// Defines sizing values with semantic meaning.
/// Values in logical pixels (dp).
@immutable
final class SemanticDimensions {
  const SemanticDimensions();

  /// Minimum tap target size (WCAG 2.2 AAA = 24dp)
  double get tapTargetMin => 24.0;
}
