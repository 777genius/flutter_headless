import 'package:flutter/material.dart';

import 'phone_field_showcase_hero_copy.dart';
import 'phone_field_showcase_hero_preview.dart';

class PhoneFieldShowcaseHero extends StatelessWidget {
  const PhoneFieldShowcaseHero({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.92),
            scheme.tertiaryContainer.withValues(alpha: 0.72),
            scheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: const _PhoneFieldHeroMainRow(),
      ),
    );
  }
}

class _PhoneFieldHeroMainRow extends StatelessWidget {
  const _PhoneFieldHeroMainRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < 860;

        if (vertical) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhoneFieldShowcaseHeroCopy(),
              SizedBox(height: 24),
              PhoneFieldShowcaseHeroPreview(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: PhoneFieldShowcaseHeroCopy()),
            SizedBox(width: 24),
            Expanded(flex: 5, child: PhoneFieldShowcaseHeroPreview()),
          ],
        );
      },
    );
  }
}
