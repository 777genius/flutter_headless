import 'package:meta/meta.dart';

import 'button_tokens.dart';

export 'button_tokens.dart';

/// Component tokens registry.
///
/// Provides access to all component-specific token sets.
/// Each component has its own token class that references
/// global semantic primitives.
@immutable
final class ComponentTokens {
  const ComponentTokens();

  /// Button component tokens
  ButtonTokens get button => const ButtonTokens();
}
