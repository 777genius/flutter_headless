import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_test_helpers.dart';

class AutocompleteManyItemsScenario extends StatefulWidget {
  const AutocompleteManyItemsScenario({
    super.key,
    this.openOnFocus = false,
    this.openOnInput = false,
    this.openOnTap = true,
    this.presentation = RAutocompleteSelectedValuesPresentation.chips,
  });

  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final RAutocompleteSelectedValuesPresentation presentation;

  @override
  State<AutocompleteManyItemsScenario> createState() =>
      _AutocompleteManyItemsScenarioState();
}

class _AutocompleteManyItemsScenarioState extends State<AutocompleteManyItemsScenario> {
  static const _items = <String>[
    'Argentina',
    'Australia',
    'Austria',
    'Belgium',
    'Brazil',
    'Canada',
    'Chile',
    'China',
    'Czechia',
    'Denmark',
    'Egypt',
    'Finland',
    'France',
    'Germany',
    'Greece',
    'Hungary',
    'India',
    'Indonesia',
    'Ireland',
    'Italy',
    'Japan',
    'Kenya',
    'Latvia',
    'Lithuania',
    'Luxembourg',
    'Malaysia',
    'Mexico',
    'Netherlands',
    'Norway',
    'Poland',
    'Portugal',
    'Romania',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'South Africa',
    'Spain',
    'Sweden',
    'Switzerland',
    'Thailand',
    'Ukraine',
    'United Kingdom',
    'United States',
    'Vietnam',
  ];

  final HeadlessItemAdapter<String> _adapter = HeadlessItemAdapter(
    id: (v) => ListboxItemId(v),
    primaryText: (v) => v,
    searchText: (v) => v,
  );

  List<String> _selected = const [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RAutocomplete<String>.multiple(
              key: AutocompleteTestKeys.field,
              source: RAutocompleteLocalSource(
                options: (value) => _filter(_items, value),
              ),
              itemAdapter: _adapter,
              selectedValues: _selected,
              onSelectionChanged: (next) => setState(() => _selected = next),
              openOnFocus: widget.openOnFocus,
              openOnInput: widget.openOnInput,
              openOnTap: widget.openOnTap,
              selectedValuesPresentation: widget.presentation,
              placeholder: 'Select countries',
            ),
            const SizedBox(height: 16),
            Text(
              'Selected: ${_selected.join(', ')}',
              key: AutocompleteTestKeys.multiSelectionLabel,
            ),
          ],
        ),
      ),
    );
  }

  Iterable<String> _filter(
    List<String> items,
    TextEditingValue value,
  ) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) => item.toLowerCase().contains(query));
  }
}

