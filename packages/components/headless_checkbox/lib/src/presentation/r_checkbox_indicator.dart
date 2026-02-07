import 'package:flutter/widgets.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_theme/headless_theme.dart';

/// Non-interactive checkbox visual used by composite components.
class RCheckboxIndicator extends StatelessWidget {
  const RCheckboxIndicator({
    super.key,
    required this.spec,
    required this.state,
    this.slots,
    this.overrides,
  });

  final RCheckboxSpec spec;
  final RCheckboxState state;
  final RCheckboxSlots? slots;
  final RenderOverrides? overrides;

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RCheckboxRenderer>(
      context,
      componentName: 'RCheckboxIndicator',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RCheckboxRenderer',
              componentName: 'RCheckboxIndicator',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_checkbox',
          context: ErrorDescription('while building RCheckboxIndicator'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RCheckboxIndicator',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RCheckboxRenderer',
        ),
      );
    }
    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RCheckboxTokenResolver>();

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      overrides: overrides,
    );

    return renderer.render(
      RCheckboxRenderRequest(
        context: context,
        spec: spec,
        state: state,
        slots: slots,
        resolvedTokens: resolvedTokens,
        overrides: overrides,
      ),
    );
  }
}
