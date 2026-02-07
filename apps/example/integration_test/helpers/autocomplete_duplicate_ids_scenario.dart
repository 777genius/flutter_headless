import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_test_helpers.dart';

@immutable
final class DuplicateIdItem {
  const DuplicateIdItem(this.label, this.id);
  final String label;
  final String id;
}

class AutocompleteDuplicateIdsScenario extends StatefulWidget {
  const AutocompleteDuplicateIdsScenario({super.key});

  @override
  State<AutocompleteDuplicateIdsScenario> createState() =>
      _AutocompleteDuplicateIdsScenarioState();
}

class _AutocompleteDuplicateIdsScenarioState
    extends State<AutocompleteDuplicateIdsScenario> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final items = const <DuplicateIdItem>[
      DuplicateIdItem('Alpha-1', 'dup'),
      DuplicateIdItem('Alpha-2', 'dup'),
      DuplicateIdItem('Beta', 'beta'),
    ];

    final adapter = HeadlessItemAdapter<DuplicateIdItem>(
      id: (v) => ListboxItemId(v.id),
      primaryText: (v) => v.label,
      searchText: (v) => v.label,
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RAutocomplete<DuplicateIdItem>(
            key: AutocompleteTestKeys.field,
            source: RAutocompleteLocalSource(options: (_) => items),
            itemAdapter: adapter,
            onSelected: (v) => setState(() => _selected = v.label),
            openOnTap: true,
            openOnInput: false,
            openOnFocus: false,
            placeholder: 'Dup ids',
          ),
          const SizedBox(height: 16),
          Text('Selected: ${_selected ?? 'none'}'),
        ],
      ),
    );
  }
}
