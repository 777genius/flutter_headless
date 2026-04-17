import 'package:flutter/material.dart';

import 'phone_field_navigator_demo_section.dart';
import 'showcase_fact_pill.dart';

final class PhoneFieldNavigatorStatus extends StatelessWidget {
  const PhoneFieldNavigatorStatus({
    required this.mode,
    required this.countryCode,
    required this.internationalValue,
    super.key,
  });

  final PhoneFieldDemoNavigatorMode mode;
  final String countryCode;
  final String internationalValue;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        ShowcaseFactPill(label: 'Flow', value: mode.label),
        ShowcaseFactPill(label: 'Country', value: countryCode),
        ShowcaseFactPill(label: 'International', value: internationalValue),
      ],
    );
  }
}
