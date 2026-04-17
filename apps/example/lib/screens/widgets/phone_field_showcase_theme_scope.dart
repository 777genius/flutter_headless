import 'package:flutter/widgets.dart';

import 'showcase_text_field_scope.dart';

class PhoneFieldShowcaseThemeScope extends StatelessWidget {
  const PhoneFieldShowcaseThemeScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShowcaseTextFieldScope(
      child: child,
    );
  }
}
