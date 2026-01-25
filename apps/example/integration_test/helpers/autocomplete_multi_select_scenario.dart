import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_test_helpers.dart';

class AutocompleteMultiSelectScenario extends StatefulWidget {
  const AutocompleteMultiSelectScenario({
    super.key,
    this.openOnFocus = false,
    this.openOnInput = false,
    this.openOnTap = true,
    this.hideSelectedOptions = false,
    this.pinSelectedOptions = false,
    this.presentation = RAutocompleteSelectedValuesPresentation.chips,
    this.initialValue,
    this.includeFocusTarget = false,
  });

  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final bool hideSelectedOptions;
  final bool pinSelectedOptions;
  final RAutocompleteSelectedValuesPresentation presentation;
  final TextEditingValue? initialValue;
  final bool includeFocusTarget;

  @override
  State<AutocompleteMultiSelectScenario> createState() =>
      _AutocompleteMultiSelectScenarioState();
}

class _AutocompleteMultiSelectScenarioState
    extends State<AutocompleteMultiSelectScenario> {
  List<String> _selected = const [];

  @override
  Widget build(BuildContext context) {
    final items = AutocompleteTestItems.countries;
    final adapter = AutocompleteTestItems.adapter;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RAutocomplete<String>.multiple(
              key: AutocompleteTestKeys.field,
              source: RAutocompleteLocalSource(
                options: (value) => _filter(items, value),
              ),
              itemAdapter: adapter,
              selectedValues: _selected,
              onSelectionChanged: (next) => setState(() => _selected = next),
              openOnFocus: widget.openOnFocus,
              openOnInput: widget.openOnInput,
              openOnTap: widget.openOnTap,
              hideSelectedOptions: widget.hideSelectedOptions,
              pinSelectedOptions: widget.pinSelectedOptions,
              selectedValuesPresentation: widget.presentation,
              initialValue: widget.initialValue,
              placeholder: 'Select countries',
            ),
            if (widget.includeFocusTarget) ...[
              const SizedBox(height: 16),
              Focus(
                child: Container(
                  key: const Key('other_focus_target'),
                  height: 40,
                  color: Colors.transparent,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Selected: ${_selected.join(', ')}',
              key: AutocompleteTestKeys.multiSelectionLabel,
            ),
            const SizedBox(height: 4),
            Text(
              'Count: ${_selected.length}',
              key: AutocompleteTestKeys.multiCountLabel,
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

