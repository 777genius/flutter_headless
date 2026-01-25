import 'package:flutter/widgets.dart';

/// Optional renderer policy for stricter contracts in debug/test.
@immutable
final class HeadlessRendererPolicy {
  const HeadlessRendererPolicy({
    this.requireResolvedTokens = false,
  });

  /// When true, renderers must receive non-null resolvedTokens.
  ///
  /// Useful for enforcing tokens-only pipelines in debug/test.
  final bool requireResolvedTokens;
}
