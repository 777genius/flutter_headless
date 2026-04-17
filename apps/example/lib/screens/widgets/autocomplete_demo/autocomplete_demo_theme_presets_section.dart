import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../../../theme_mode_scope.dart';
import '../demo_section.dart';
import '../demo_mode_palette.dart';
import 'autocomplete_demo_countries.dart';

class AutocompleteDemoThemePresetsSection extends StatelessWidget {
  const AutocompleteDemoThemePresetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;
    final modeLabel = isCupertino ? 'Cupertino' : 'Material';

    return DemoSection(
      title: 'Theme Presets',
      description:
          'These fields use the active headless preset from the header. '
          'Switch Material/Cupertino above to compare the same autocomplete API.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AutocompleteThemePresetStatus(modeLabel: modeLabel),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final cardWidth =
                  isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const _PurePresetAutocompleteCard(),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _SlotFriendlyPresetAutocompleteCard(),
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

class _AutocompleteThemePresetStatus extends StatelessWidget {
  const _AutocompleteThemePresetStatus({required this.modeLabel});

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

class _AutocompletePresetCard extends StatelessWidget {
  const _AutocompletePresetCard({
    required this.title,
    required this.caption,
    required this.child,
  });

  final String title;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = DemoModePalette.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.secondaryText,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _PurePresetAutocompleteCard extends StatelessWidget {
  const _PurePresetAutocompleteCard();

  @override
  Widget build(BuildContext context) {
    return _AutocompletePresetCard(
      title: 'Pure preset',
      caption: 'The active preset renders both field and menu.',
      child: RAutocomplete<AutocompleteDemoCountry>(
        source: RAutocompleteLocalSource(
          options: filterAutocompleteDemoCountries,
        ),
        itemAdapter: autocompleteDemoCountryRichAdapter,
        onSelected: (_) {},
        placeholder: 'Search country or dial code',
        semanticLabel: 'Theme preset autocomplete',
        maxOptions: 4,
      ),
    );
  }
}

class _SlotFriendlyPresetAutocompleteCard extends StatelessWidget {
  const _SlotFriendlyPresetAutocompleteCard();

  @override
  Widget build(BuildContext context) {
    return _AutocompletePresetCard(
      title: 'Preset + slots',
      caption: 'Same preset, with a leading search affordance.',
      child: RAutocomplete<AutocompleteDemoCountry>(
        source: RAutocompleteLocalSource(
          options: filterAutocompleteDemoCountries,
        ),
        itemAdapter: autocompleteDemoCountryRichAdapter,
        onSelected: (_) {},
        placeholder: 'Find a route country',
        semanticLabel: 'Theme preset autocomplete with slots',
        maxOptions: 4,
        fieldSlots: const RTextFieldSlots(
          leading: Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
