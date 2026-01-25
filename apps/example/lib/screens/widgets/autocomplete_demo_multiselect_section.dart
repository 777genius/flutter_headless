import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_demo_country.dart';
import 'demo_section.dart';

class AutocompleteDemoMultiSelectSection extends StatefulWidget {
  const AutocompleteDemoMultiSelectSection({super.key});

  @override
  State<AutocompleteDemoMultiSelectSection> createState() =>
      _AutocompleteDemoMultiSelectSectionState();
}

class _AutocompleteDemoMultiSelectSectionState
    extends State<AutocompleteDemoMultiSelectSection> {
  List<AutocompleteDemoCountry> _selected = const [];
  var _presentation = RAutocompleteSelectedValuesPresentation.chips;
  var _hideSelected = false;
  var _pinSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return DemoSection(
      title: 'D3 - Multi-select Autocomplete',
      description:
          'Multiple selection with checkboxes in menu + tokens inside the field.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _ToggleChip(
                label: 'Chips',
                selected: _presentation ==
                    RAutocompleteSelectedValuesPresentation.chips,
                onSelected: () => setState(() {
                  _presentation = RAutocompleteSelectedValuesPresentation.chips;
                }),
              ),
              _ToggleChip(
                label: 'CSV',
                selected: _presentation ==
                    RAutocompleteSelectedValuesPresentation.commaSeparated,
                onSelected: () => setState(() {
                  _presentation =
                      RAutocompleteSelectedValuesPresentation.commaSeparated;
                }),
              ),
              _ToggleChip(
                label: 'Hide selected',
                selected: _hideSelected,
                onSelected: () => setState(() => _hideSelected = !_hideSelected),
              ),
              _ToggleChip(
                label: 'Pin selected',
                selected: _pinSelected,
                onSelected: () => setState(() => _pinSelected = !_pinSelected),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RAutocomplete<AutocompleteDemoCountry>.multiple(
            source: RAutocompleteLocalSource(
              options: filterAutocompleteDemoCountries,
            ),
            itemAdapter: autocompleteDemoCountryAdapter,
            selectedValues: _selected,
            onSelectionChanged: (values) => setState(() => _selected = values),
            placeholder: 'Select multiple countries',
            semanticLabel: 'Multi-select country search',
            maxOptions: 8,
            hideSelectedOptions: _hideSelected,
            pinSelectedOptions: _pinSelected,
            selectedValuesPresentation: _presentation,
            fieldSlots: RTextFieldSlots(
              leading: Icon(Icons.search, color: hintColor),
            ),
          ),
          const SizedBox(height: 8),
          Text('Selected count: ${_selected.length}'),
          const SizedBox(height: 4),
          Text(
            'Backspace on empty query removes last. Selecting clears query.',
            style: theme.textTheme.bodySmall?.copyWith(color: hintColor),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

