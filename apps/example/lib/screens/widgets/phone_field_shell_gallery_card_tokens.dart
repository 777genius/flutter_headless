import 'package:flutter/material.dart';

import 'phone_field_shell_gallery_preset.dart';

EdgeInsets phoneFieldShellCardPadding(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const EdgeInsets.fromLTRB(20, 18, 20, 18),
      PhoneFieldShellPreset.minimal =>
        const EdgeInsets.fromLTRB(22, 18, 22, 24),
      PhoneFieldShellPreset.travel => const EdgeInsets.fromLTRB(22, 20, 22, 22),
      PhoneFieldShellPreset.console =>
        const EdgeInsets.fromLTRB(22, 20, 22, 22),
    };

double phoneFieldShellHeaderGap(PhoneFieldShellPreset preset) =>
    preset == PhoneFieldShellPreset.soft ? 10 : 14;

double phoneFieldShellFactsGap(PhoneFieldShellPreset preset) =>
    preset == PhoneFieldShellPreset.soft ? 12 : 18;

double phoneFieldShellFieldSectionGap(PhoneFieldShellPreset preset) =>
    preset == PhoneFieldShellPreset.soft ? 12 : 18;

double phoneFieldShellCaptionGap(PhoneFieldShellPreset preset) =>
    preset == PhoneFieldShellPreset.soft ? 6 : 10;

Color phoneFieldShellAccentColor(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const Color(0xFF7D5DCA),
      PhoneFieldShellPreset.minimal => const Color(0xFF9A5A1B),
      PhoneFieldShellPreset.travel => const Color(0xFF2E78C7),
      PhoneFieldShellPreset.console => const Color(0xFF9BE66E),
    };

Color phoneFieldShellTitleColor(
  BuildContext context,
  PhoneFieldShellPreset preset,
) {
  if (preset == PhoneFieldShellPreset.console) {
    return const Color(0xFFEAF7DF);
  }
  return Theme.of(context).colorScheme.onSurface;
}

Color phoneFieldShellBodyColor(
  BuildContext context,
  PhoneFieldShellPreset preset,
) {
  if (preset == PhoneFieldShellPreset.console) {
    return const Color(0xFFC4D3BE);
  }
  return Theme.of(context).colorScheme.onSurfaceVariant;
}

String phoneFieldShellFactPrimary(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => 'Leading chip',
      PhoneFieldShellPreset.minimal => 'Trailing selector',
      PhoneFieldShellPreset.travel => 'Segmented launcher',
      PhoneFieldShellPreset.console => 'Hard badge',
    };

String phoneFieldShellFactSecondary(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => 'Commerce spacing',
      PhoneFieldShellPreset.minimal => 'Editorial rhythm',
      PhoneFieldShellPreset.travel => 'Airside layout',
      PhoneFieldShellPreset.console => 'Dense data shell',
    };
