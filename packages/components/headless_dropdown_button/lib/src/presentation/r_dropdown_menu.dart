import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_dropdown_menu_state.dart';

/// Overlay menu widget that re-renders on menu state changes.
///
/// Focus is managed by the parent dropdown which passes [focusNode] and decides
/// when to transfer focus.
final class RDropdownMenu extends StatelessWidget {
  const RDropdownMenu({
    required this.stateNotifier,
    required this.focusNode,
    required this.createMenuRequest,
    required this.onKeyEvent,
    super.key,
  });

  final ValueListenable<RDropdownMenuState> stateNotifier;
  final FocusNode focusNode;
  final RDropdownMenuRenderRequest Function(BuildContext) createMenuRequest;
  final KeyEventResult Function(FocusNode, KeyEvent) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: onKeyEvent,
      child: ValueListenableBuilder<RDropdownMenuState>(
        valueListenable: stateNotifier,
        builder: (context, menuState, _) {
          final renderer =
              HeadlessThemeProvider.maybeCapabilityOf<RDropdownButtonRenderer>(
            context,
            componentName: 'RDropdownButton',
          );
          if (renderer == null) {
            final hasTheme = HeadlessThemeProvider.of(context) != null;
            final exception = hasTheme
                ? const MissingCapabilityException(
                    capabilityType: 'RDropdownButtonRenderer',
                    componentName: 'RDropdownButton',
                  )
                : const MissingThemeException();
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: exception,
                stack: StackTrace.current,
                library: 'headless_dropdown_button',
                context: ErrorDescription('while building RDropdownMenu'),
              ),
            );
            return HeadlessMissingCapabilityWidget(
              componentName: 'RDropdownButton',
              message: headlessMissingCapabilityWidgetMessage(
                missingCapabilityType: 'RDropdownButtonRenderer',
              ),
            );
          }

          final request = createMenuRequest(context);
          final content = renderer.render(request);
          _reportUnconsumedOverrides('RDropdownButton', request.overrides);
          return content;
        },
      ),
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
