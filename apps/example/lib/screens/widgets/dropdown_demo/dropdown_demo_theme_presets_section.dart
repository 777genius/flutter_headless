import 'package:flutter/material.dart';

import '../../../theme_mode_scope.dart';
import '../demo_section.dart';
import '../demo_mode_palette.dart';
import 'dropdown_demo_theme_pure_preset_card.dart';
import 'dropdown_demo_theme_rich_preset_card.dart';

class DropdownDemoThemePresetsSection extends StatelessWidget {
  const DropdownDemoThemePresetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;
    final modeLabel = isCupertino ? 'Cupertino' : 'Material';

    return DemoSection(
      title: 'Theme Presets',
      description:
          'These selectors use the active headless preset from the header. '
          'Switch Material/Cupertino above to compare the same dropdown API.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DropdownThemePresetStatus(modeLabel: modeLabel),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final cardWidth = isWide
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const DropdownDemoThemePurePresetCard(),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const DropdownDemoThemeRichPresetCard(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DropdownThemePresetStatus extends StatelessWidget {
  const _DropdownThemePresetStatus({required this.modeLabel});

  final String modeLabel;

  @override
  Widget build(BuildContext context) {
    final palette = DemoModePalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.accentSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.compare_arrows_rounded, color: palette.accentForeground),
          const SizedBox(width: 8),
          Text(
            '$modeLabel preset active',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.accentForeground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
