import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';
import 'package:headless_pinput/headless_pinput.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

import 'headless_example_app.dart';

void main() {
  MarionetteBinding.ensureInitialized(
    MarionetteConfiguration(
      isInteractiveWidget: (type) => type == RPinInput || type == RPhoneField,
      extractText: (element) {
        final widget = element.widget;
        if (widget is RPhoneField) {
          return widget.label ?? widget.placeholder ?? 'Headless phone field';
        }
        if (widget is RPinInput) {
          return 'Headless PIN input';
        }
        return null;
      },
    ),
  );

  runApp(const HeadlessExampleApp(initialRoute: '/phone-field'));
}
