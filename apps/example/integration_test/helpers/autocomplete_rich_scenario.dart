import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_rich_item_row.dart';
import 'autocomplete_test_helpers.dart';

class AutocompleteRichScenario extends StatefulWidget {
  const AutocompleteRichScenario({
    super.key,
    this.disabled = false,
    this.openOnFocus = true,
    this.openOnInput = true,
    this.openOnTap = true,
    this.initialValue,
  });

  final bool disabled;
  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final TextEditingValue? initialValue;

  @override
  State<AutocompleteRichScenario> createState() =>
      _AutocompleteRichScenarioState();
}

class _AutocompleteRichScenarioState extends State<AutocompleteRichScenario> {
  AutocompleteTestCountry? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RAutocomplete<AutocompleteTestCountry>(
            key: AutocompleteTestKeys.field,
            source: RAutocompleteLocalSource(
              options: AutocompleteRichTestItems.filter,
            ),
            itemAdapter: AutocompleteRichTestItems.adapter,
            onSelected: (value) => setState(() => _selectedValue = value),
            openOnFocus: widget.openOnFocus,
            openOnInput: widget.openOnInput,
            openOnTap: widget.openOnTap,
            disabled: widget.disabled,
            initialValue: widget.initialValue,
            placeholder: 'Search country',
            menuSlots: RDropdownButtonSlots(
              itemContent: Replace(
                (ctx) => AutocompleteRichItemRow(
                  item: ctx.item,
                  index: ctx.index,
                  isSelected: ctx.isSelected,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Selected: ${_selectedValue?.name ?? 'none'}',
            key: AutocompleteTestKeys.selectionLabel,
          ),
        ],
      ),
    );
  }
}
