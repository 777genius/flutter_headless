# Users Cookbook

This cookbook contains copy-paste ready recipes. Each example is minimal and can be dropped into a Flutter project that already uses a Headless preset.

If you need more:
- TextField: `docs/users/COOKBOOK_TEXTFIELD.md`
- Autocomplete: `docs/users/COOKBOOK_AUTOCOMPLETE.md`
- Advanced (scopes + defaults): `docs/users/COOKBOOK_ADVANCED.md`
- Guardrails: `docs/users/GUARDRAILS.md`

## Button style

Use `style:` for quick per-instance customization.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_button/headless_button.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RTextButton(
      onPressed: () {},
      style: const RButtonStyle(
        backgroundColor: Color(0xFF0066FF),
        foregroundColor: Color(0xFFFFFFFF),
        radius: 12,
      ),
      child: const Text('Save'),
    );
  }
}
```

## Button slots (decorate surface)

Use `slots:` for partial customization without reimplementing a renderer.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';

class FancyButton extends StatelessWidget {
  const FancyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RTextButton(
      onPressed: () {},
      slots: RButtonSlots(
        surface: Decorate(
          (ctx, child) => DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4B6FFF), Color(0xFF7B4BFF)],
              ),
            ),
            child: child,
          ),
        ),
      ),
      child: const Text('Upgrade'),
    );
  }
}
```

## Dropdown with items

Use `RDropdownButton<T>` with an item adapter. This is the select-like control.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return RDropdownButton<String>(
      items: const ['Paris', 'Berlin', 'Tokyo'],
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v,
      ),
      value: 'Paris',
      onChanged: (_) {},
    );
  }
}
```

## Dropdown menu style (simple)

If you only need to change colors / radius, use `style:` (token-level).

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return RDropdownButton<String>(
      items: const ['Paris', 'Berlin', 'Tokyo'],
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v,
      ),
      value: 'Paris',
      onChanged: (_) {},
      style: const RDropdownStyle(
        menuBackgroundColor: Color(0xFFFFFFFF),
        menuBorderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
```

## Dropdown menu surface (wrap / structure)

If you need to wrap structure (clip/shadow/animation/custom surface), use `menuSurface: Decorate(...)`.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return RDropdownButton<String>(
      items: const ['Paris', 'Berlin', 'Tokyo'],
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v,
      ),
      value: 'Paris',
      onChanged: (_) {},
      slots: RDropdownButtonSlots(
        menuSurface: Decorate(
          (ctx, child) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

## Checkbox slots (decorate box)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
import 'package:headless_contracts/headless_contracts.dart';

class ConsentCheckbox extends StatelessWidget {
  const ConsentCheckbox({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RCheckbox(
      value: value,
      onChanged: onChanged,
      slots: RCheckboxSlots(
        box: Decorate(
          (ctx, child) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

## Dropdown multi-select item row (checkbox + label)

This keeps behavior intact, but changes visuals for multi-select rows.

```dart
import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';

class MultiSelectCityDropdown extends StatelessWidget {
  const MultiSelectCityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return RDropdownButton<String>(
      items: const ['Paris', 'Berlin', 'Tokyo'],
      itemAdapter: HeadlessItemAdapter.simple(
        id: (v) => ListboxItemId(v),
        titleText: (v) => v,
      ),
      selectedValues: const ['Paris'],
      onSelectionChanged: (_) {},
      slots: RDropdownButtonSlots(
        itemContent: Decorate(
          (ctx, child) => Row(
            children: [
              IgnorePointer(
                child: Checkbox(
                  value: ctx.isSelected,
                  onChanged: null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
```

## CheckboxListTile tile slot (decorate)

Wrap the default tile without taking over activation.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
import 'package:headless_contracts/headless_contracts.dart';

class ConsentTile extends StatelessWidget {
  const ConsentTile({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RCheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: const Text('I agree'),
      slots: RCheckboxListTileSlots(
        tile: Decorate(
          (ctx, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

## SafeDropdownRenderer (full takeover, minimal template)

Use this when you need a fully custom dropdown renderer but still want safe defaults.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

final safe = SafeDropdownRenderer(
  buildTrigger: (ctx) => ctx.child,
  buildMenuSurface: (ctx) => ctx.child,
  buildItem: (ctx) => ctx.child,
);
```

