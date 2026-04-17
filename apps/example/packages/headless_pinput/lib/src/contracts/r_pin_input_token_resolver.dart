import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_pin_input_renderer.dart';
import 'r_pin_input_resolved_tokens.dart';

abstract interface class RPinInputTokenResolver {
  RPinInputResolvedTokens resolve({
    required BuildContext context,
    required RPinInputSpec spec,
    required RPinInputState state,
    required RenderOverrides? overrides,
  });
}
