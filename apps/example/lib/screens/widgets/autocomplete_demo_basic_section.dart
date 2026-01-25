import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_demo_country.dart';
import 'demo_section.dart';

class AutocompleteDemoBasicSection extends StatefulWidget {
  const AutocompleteDemoBasicSection({super.key});

  @override
  State<AutocompleteDemoBasicSection> createState() =>
      _AutocompleteDemoBasicSectionState();
}

class _AutocompleteDemoBasicSectionState
    extends State<AutocompleteDemoBasicSection> {
  AutocompleteDemoCountry? _selected;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _selected?.name ?? 'none';
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return DemoSection(
      title: 'D1 - Default Autocomplete',
      description:
          'Default Material menu and TextField renderer with filtering.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RAutocomplete<AutocompleteDemoCountry>(
            source: RAutocompleteLocalSource(
              options: filterAutocompleteDemoCountries,
            ),
            itemAdapter: autocompleteDemoCountryAdapter,
            onSelected: (value) => setState(() => _selected = value),
            placeholder: 'Search country',
            semanticLabel: 'Country search',
          ),
          const SizedBox(height: 8),
          Text('Selected: $selectedLabel'),
          const SizedBox(height: 4),
          Text(
            'Type to filter, ArrowDown to open and navigate.',
            style: theme.textTheme.bodySmall?.copyWith(color: hintColor),
          ),
        ],
      ),
    );
  }
}
