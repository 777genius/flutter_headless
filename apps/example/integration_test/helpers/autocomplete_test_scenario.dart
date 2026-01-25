import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_test_helpers.dart';

class AutocompleteTestScenario extends StatefulWidget {
  const AutocompleteTestScenario({
    super.key,
    this.disabled = false,
    this.openOnFocus = true,
    this.openOnInput = true,
    this.openOnTap = true,
    this.closeOnSelected = true,
    this.initialValue,
    this.items,
    this.itemAdapter,
  });

  final bool disabled;
  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final bool closeOnSelected;
  final TextEditingValue? initialValue;
  final List<String>? items;
  final HeadlessItemAdapter<String>? itemAdapter;

  @override
  State<AutocompleteTestScenario> createState() =>
      _AutocompleteTestScenarioState();
}

class _AutocompleteTestScenarioState extends State<AutocompleteTestScenario> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final items = widget.items ?? AutocompleteTestItems.countries;
    final adapter = widget.itemAdapter ?? AutocompleteTestItems.adapter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RAutocomplete<String>(
            key: AutocompleteTestKeys.field,
            source: RAutocompleteLocalSource(
              options: (value) => _filterAutocompleteItems(items, value),
            ),
            itemAdapter: adapter,
            onSelected: (value) => setState(() => _selectedValue = value),
            openOnFocus: widget.openOnFocus,
            openOnInput: widget.openOnInput,
            openOnTap: widget.openOnTap,
            closeOnSelected: widget.closeOnSelected,
            disabled: widget.disabled,
            initialValue: widget.initialValue,
            placeholder: 'Search country',
          ),
          const SizedBox(height: 16),
          Text(
            'Selected: ${_selectedValue ?? 'none'}',
            key: AutocompleteTestKeys.selectionLabel,
          ),
        ],
      ),
    );
  }

  Iterable<String> _filterAutocompleteItems(
    List<String> items,
    TextEditingValue value,
  ) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return const <String>[];
    return items.where((item) => item.toLowerCase().contains(query));
  }
}
