import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_autocomplete_menu_state.dart';

/// Overlay menu widget that re-renders on menu state changes.
final class RAutocompleteMenuOverlay extends StatelessWidget {
  const RAutocompleteMenuOverlay({
    required this.stateNotifier,
    required this.createMenuRequest,
    required this.anchorFocusNode,
    super.key,
  });

  final ValueListenable<RAutocompleteMenuState> stateNotifier;
  final RDropdownMenuRenderRequest Function(BuildContext) createMenuRequest;
  final FocusNode anchorFocusNode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RAutocompleteMenuState>(
      valueListenable: stateNotifier,
      builder: (context, _, __) {
        final renderer =
            HeadlessThemeProvider.maybeCapabilityOf<RDropdownButtonRenderer>(
          context,
          componentName: 'RAutocomplete',
        );
        if (renderer == null) {
          final hasTheme = HeadlessThemeProvider.of(context) != null;
          final exception = hasTheme
              ? const MissingCapabilityException(
                  capabilityType: 'RDropdownButtonRenderer',
                  componentName: 'RAutocomplete',
                )
              : const MissingThemeException();
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: exception,
              stack: StackTrace.current,
              library: 'headless_autocomplete',
              context: ErrorDescription('while building RAutocompleteMenuOverlay'),
            ),
          );
          return HeadlessMissingCapabilityWidget(
            componentName: 'RAutocomplete',
            message: headlessMissingCapabilityWidgetMessage(
              missingCapabilityType: 'RDropdownButtonRenderer',
            ),
          );
        }

        final request = createMenuRequest(context);
        final content = renderer.render(request);
        _reportUnconsumedOverrides('RAutocomplete', request.overrides);
        // Important: treat menu taps as part of the text field region so tapping
        // menu items doesn't steal focus from the EditableText (which would
        // close the menu via focus-loss).
        return TextFieldTapRegion(
          groupId: anchorFocusNode,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              // Extra safety: some platforms still unfocus EditableText on
              // pointer-down in overlay. Keep focus on the anchor.
              if (!anchorFocusNode.hasFocus) {
                anchorFocusNode.requestFocus();
              }
            },
            child: content,
          ),
        );
      },
    );
  }

  void _reportUnconsumedOverrides(
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
}
