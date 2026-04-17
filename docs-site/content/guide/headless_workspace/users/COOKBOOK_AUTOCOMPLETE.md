---
sidebar_position: 5
sidebar_label: "Autocomplete Recipes"
---
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
      semanticLabel: 'Country autocomplete',
      maxOptions: 6,
    );
  }
}
```

## Async / typeahead (remote source)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';

class User {
  const User({required this.id, required this.name});
  final String id;
  final String name;
}

final _userAdapter = HeadlessItemAdapter.simple<User>(
  id: (u) => ListboxItemId(u.id),
  titleText: (u) => u.name,
);

class UserAutocomplete extends StatelessWidget {
  const UserAutocomplete({super.key, required this.searchUsers});

  final Future<List<User>> Function(String query) searchUsers;

  @override
  Widget build(BuildContext context) {
    return RAutocomplete<User>(
      source: RAutocompleteRemoteSource(
        load: (query) => searchUsers(query.text),
        policy: const RAutocompleteRemotePolicy(
          query: RAutocompleteQueryPolicy(minQueryLength: 2),
          debounce: Duration(milliseconds: 250),
          loadOnInput: true,
        ),
      ),
      itemAdapter: _userAdapter,
      onSelected: (_) {},
      placeholder: 'Search users',
      semanticLabel: 'User search autocomplete',
    );
  }
}
```

## Rich items (flag + subtitle + trailing)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';

class Country {
  const Country({
    required this.isoCode,
    required this.name,
    required this.dialCode,
    required this.flagEmoji,
  });

  final String isoCode;
  final String name;
  final String dialCode;
  final String flagEmoji;
}

final _richCountryAdapter = HeadlessItemAdapter<Country>(
  id: (country) => ListboxItemId(country.isoCode),
  primaryText: (country) => country.name,
  subtitle: (country) => HeadlessContent.text(country.dialCode),
  leading: (country) => HeadlessContent.emoji(country.flagEmoji),
  trailing: (country) => HeadlessContent.text(country.isoCode),
);

class RichCountryAutocomplete extends StatelessWidget {
  const RichCountryAutocomplete({super.key, required this.items});

  final List<Country> items;

  @override
  Widget build(BuildContext context) {
    return RAutocomplete<Country>(
      source: RAutocompleteLocalSource(
        options: (value) {
          final query = value.text.trim().toLowerCase();
          if (query.isEmpty) return items;
          return items.where((country) {
            return country.name.toLowerCase().contains(query) ||
                country.isoCode.toLowerCase().contains(query) ||
                country.dialCode.toLowerCase().contains(query);
          });
        },
      ),
      itemAdapter: _richCountryAdapter,
      onSelected: (_) {},
      placeholder: 'Country or dial code',
    );
  }
}
```

## Multi-select with chips

```dart
import 'package:flutter/material.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_foundation/headless_foundation.dart';

final _tagAdapter = HeadlessItemAdapter.simple<String>(
  id: (v) => ListboxItemId(v),
  titleText: (v) => v,
);

class TagsAutocomplete extends StatefulWidget {
  const TagsAutocomplete({super.key});

  @override
  State<TagsAutocomplete> createState() => _TagsAutocompleteState();
}

class _TagsAutocompleteState extends State<TagsAutocomplete> {
  List<String> selected = const ['design'];

  @override
  Widget build(BuildContext context) {
    return RAutocomplete<String>.multiple(
      source: const RAutocompleteLocalSource(
        options: (value) => ['design', 'frontend', 'backend', 'qa', 'devops'],
      ),
      itemAdapter: _tagAdapter,
      selectedValues: selected,
      onSelectionChanged: (next) => setState(() => selected = next),
      placeholder: 'Filter by tags',
      pinSelectedOptions: true,
      hideSelectedOptions: false,
      selectedValuesPresentation: RAutocompleteSelectedValuesPresentation.chips,
      clearQueryOnSelection: true,
      semanticLabel: 'Tags multi select autocomplete',
    );
  }
}
```

## Keyboard + accessibility behavior

`RAutocomplete` already includes combobox semantics and keyboard handling:

- ArrowUp / ArrowDown: navigate options.
- Enter: select highlighted option.
- Escape: close menu.
- Home / End: jump to first/last option.
- Backspace on empty query in multi-select: removes the last selected chip.

Use `semanticLabel` for a clear screen-reader label.

## Common pitfalls

1. Use `RAutocomplete.multiple(...)` for multi-select. Single constructor asserts if you pass `selectedValues`/`onSelectionChanged`.
2. Keep `itemAdapter.id(value)` stable and unique in multi-select, otherwise toggling/removal can break.
3. For remote search, set `RAutocompleteQueryPolicy(minQueryLength: ...)` to avoid excessive requests on short queries.
4. `selectedValuesPresentation` is supported only in multiple mode.
5. If you do manual app wiring (without `HeadlessMaterialApp` / `HeadlessCupertinoApp` / `HeadlessApp`), provide required theme capabilities and overlay host.
