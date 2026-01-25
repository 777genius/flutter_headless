import 'package:flutter/foundation.dart';
import 'package:headless_contracts/renderers.dart';

/// Track overrides for debug purposes.
RenderOverrides? trackSwitchOverrides(RenderOverrides? overrides) {
  if (overrides == null) return null;
  final tracker = RenderOverridesDebugTracker();
  return RenderOverrides.debugTrack(overrides, tracker);
}

/// Report unconsumed overrides in debug mode.
void reportUnconsumedSwitchOverrides(
  String componentName,
  RenderOverrides? overrides,
) {
  assert(() {
    if (overrides == null) return true;
    final provided = overrides.debugProvidedTypes();
    if (provided.isEmpty) return true;
    final consumed = overrides.debugConsumedTypes();
    final unconsumed = provided.difference(consumed);
    if (unconsumed.isEmpty) return true;

    final message = StringBuffer()
      ..writeln('[Headless] Unconsumed RenderOverrides detected')
      ..writeln('Component: $componentName')
      ..writeln('Provided: ${provided.join(', ')}')
      ..writeln('Consumed: ${consumed.join(', ')}')
      ..writeln('Unconsumed: ${unconsumed.join(', ')}')
      ..write(
          'Hint: Your preset may not support these overrides for this component.');

    debugPrint(message.toString());
    return true;
  }());
}
