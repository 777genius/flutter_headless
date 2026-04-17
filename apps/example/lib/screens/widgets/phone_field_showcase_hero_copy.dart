import 'package:flutter/material.dart';

import 'showcase_pill.dart';

class PhoneFieldShowcaseHeroCopy extends StatelessWidget {
  const PhoneFieldShowcaseHeroCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhoneFieldHeroHeadline(),
        SizedBox(height: 14),
        _PhoneFieldHeroDescription(),
        SizedBox(height: 18),
        _PhoneFieldHeroPills(),
      ],
    );
  }
}

class _PhoneFieldHeroHeadline extends StatelessWidget {
  const _PhoneFieldHeroHeadline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'One phone field, multiple UX layers.',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
    );
  }
}

class _PhoneFieldHeroDescription extends StatelessWidget {
  const _PhoneFieldHeroDescription();

  @override
  Widget build(BuildContext context) {
    return Text(
      'This showcase adapts phone_form_field into a headless package: '
      'country-aware parsing and validation stay in the behavior layer, '
      'while the trigger visuals, slot placement, and selector navigation '
      'become fully replaceable.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
    );
  }
}

class _PhoneFieldHeroPills extends StatelessWidget {
  const _PhoneFieldHeroPills();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ShowcasePill(
          icon: Icons.check_circle_outline,
          label: 'Country-aware parsing',
        ),
        ShowcasePill(
          icon: Icons.layers_rounded,
          label: 'Scoped custom renderer',
        ),
        ShowcasePill(
          icon: Icons.draw_outlined,
          label: 'Custom trigger UI',
        ),
        ShowcasePill(
          icon: Icons.tune_rounded,
          label: 'Controller-owned logic',
        ),
      ],
    );
  }
}
