import 'package:flutter/widgets.dart';
import 'package:headless_theme/headless_theme.dart';

Widget buildMissingDropdownButtonRenderer({
  required BuildContext context,
}) {
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
      context: ErrorDescription('while building RDropdownButton'),
    ),
  );
  return HeadlessMissingCapabilityWidget(
    componentName: 'RDropdownButton',
    message: headlessMissingCapabilityWidgetMessage(
      missingCapabilityType: 'RDropdownButtonRenderer',
    ),
  );
}
