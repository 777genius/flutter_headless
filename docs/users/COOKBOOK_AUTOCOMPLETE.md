# Cookbook — Autocomplete recipes

Copy-paste ready recipes for `RAutocomplete<T>`.

## Minimal autocomplete

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';

class CountryAutocomplete extends StatelessWidget {
  const CountryAutocomplete({super.key});

  @override
  Widget build(BuildContext context) {
    const items = ['France', 'Germany', 'Japan', 'Brazil'];
    return RAutocomplete<String>(
      source: RAutocompleteLocalSource(
        options: (value) {
          final query = value.text.toLowerCase();
          return items.where((v) => v.toLowerCase().contains(query));
        },
      ),
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v,
      ),
      onSelected: (_) {},
      placeholder: 'Country',
    );
  }
}
```

