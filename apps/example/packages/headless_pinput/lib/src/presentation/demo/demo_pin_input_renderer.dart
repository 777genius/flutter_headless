import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_renderer.dart';
import 'demo_pin_input_field.dart';
import 'demo_pin_input_token_resolver.dart';

final class DemoPinInputRenderer implements RPinInputRenderer {
  const DemoPinInputRenderer({
    this.fallbackTokenResolver = const DemoPinInputTokenResolver(),
  });

  final DemoPinInputTokenResolver fallbackTokenResolver;

  @override
  Widget render(RPinInputRenderRequest request) {
    final tokens = request.resolvedTokens ??
        fallbackTokenResolver.resolve(
          context: request.context,
          spec: request.spec,
          state: request.state,
          overrides: request.overrides,
        );

    return DemoPinInputField(
      request: request,
      tokens: tokens,
    );
  }
}
