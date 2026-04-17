import 'package:flutter/widgets.dart';
import 'package:headless/headless.dart';

import 'phone_field_showcase_text_field_renderer.dart';
import 'phone_field_showcase_text_field_token_resolver.dart';

class ShowcaseTextFieldScope extends StatelessWidget {
  const ShowcaseTextFieldScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return HeadlessTextFieldScope(
      renderer: const PhoneFieldShowcaseTextFieldRenderer(),
      tokenResolver: const PhoneFieldShowcaseTextFieldTokenResolver(),
      child: child,
    );
  }
}
