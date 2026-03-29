import 'package:flutter/widgets.dart';
import 'package:headless_theme/headless_theme.dart';

Widget buildMissingSwitchRenderer({
  required BuildContext context,
  required String capabilityType,
  required String componentName,
}) {
  final hasTheme = HeadlessThemeProvider.of(context) != null;
  final exception = hasTheme
      ? MissingCapabilityException(
          capabilityType: capabilityType,
          componentName: componentName,
        )
      : const MissingThemeException();
  FlutterError.reportError(
    FlutterErrorDetails(
      exception: exception,
      stack: StackTrace.current,
      library: 'headless_switch',
      context: ErrorDescription('while building $componentName'),
    ),
  );
  return HeadlessMissingCapabilityWidget(
    componentName: componentName,
    message: headlessMissingCapabilityWidgetMessage(
      missingCapabilityType: capabilityType,
    ),
  );
}
