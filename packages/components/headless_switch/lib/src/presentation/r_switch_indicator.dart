import 'package:flutter/widgets.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_theme/headless_theme.dart';

/// Non-interactive switch visual used by composite components.
class RSwitchIndicator extends StatelessWidget {
  const RSwitchIndicator({
    super.key,
    required this.spec,
    required this.state,
    this.slots,
    this.overrides,
    this.constraints,
  });

  final RSwitchSpec spec;
  final RSwitchState state;
  final RSwitchSlots? slots;
  final RenderOverrides? overrides;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RSwitchRenderer>(
      context,
      componentName: 'RSwitchIndicator',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RSwitchRenderer',
              componentName: 'RSwitchIndicator',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_switch',
          context: ErrorDescription('while building RSwitchIndicator'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RSwitchIndicator',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RSwitchRenderer',
        ),
      );
    }
    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RSwitchTokenResolver>();

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      constraints: constraints,
      overrides: overrides,
    );

    return renderer.render(
      RSwitchRenderRequest(
        context: context,
        spec: spec,
        state: state,
        slots: slots,
        resolvedTokens: resolvedTokens,
        constraints: constraints,
        overrides: overrides,
      ),
    );
  }
}
