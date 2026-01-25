# Headless

Headless gives you Flutter UI building blocks with consistent behavior and
accessibility, while letting you swap visuals (Material, Cupertino, or your own).

- Keep interaction, keyboard, and a11y consistent.
- Use presets for visuals, without forking behavior.
- Customize per instance or per screen when needed.

## Install

This repo is a monorepo. Bootstrap once:

```bash
melos bootstrap
```

## 60s quick start (Material)

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessMaterialApp(home: Demo()));
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  bool _checked = false;
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RTextButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            RDropdownButton<String>(
              items: const ['Paris', 'Berlin', 'Tokyo'],
              itemAdapter: HeadlessItemAdapter.simple(
                id: (v) => ListboxItemId(v),
                titleText: (v) => v,
              ),
              value: _city,
              onChanged: (v) => setState(() => _city = v),
            ),
            const SizedBox(height: 16),
            RCheckboxListTile(
              value: _checked,
              onChanged: (v) => setState(() => _checked = v ?? false),
              title: const Text('I agree'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Customization in 30s (safe path)

These examples customize visuals without reimplementing a renderer.

### Button (decorate surface)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';

RTextButton(
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
)
```

### Dropdown (style)

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';

RDropdownButton<String>(
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
)
```

If you need to wrap or replace structure (clip/shadow/animation/custom surfaces), use slots instead:
`RDropdownButtonSlots(menuSurface: Decorate((ctx, child) => ...))`.

## Quick start (Cupertino)

```dart
import 'package:flutter/cupertino.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_cupertino/headless_cupertino.dart';

void main() {
  runApp(const HeadlessCupertinoApp(home: Demo()));
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  bool _checked = false;
  String? _city;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Headless (Cupertino)')),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RTextButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
              RDropdownButton<String>(
                items: const ['Paris', 'Berlin', 'Tokyo'],
                itemAdapter: HeadlessItemAdapter.simple(
                  id: (v) => ListboxItemId(v),
                  titleText: (v) => v,
                ),
                value: _city,
                onChanged: (v) => setState(() => _city = v),
              ),
              const SizedBox(height: 16),
              RCheckboxListTile(
                value: _checked,
                onChanged: (v) => setState(() => _checked = v ?? false),
                title: const Text('I agree'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Where to go next

- Users Guide: `docs/users/README.md`
- Users Cookbook: `docs/users/COOKBOOK.md`
- Guardrails for customization: `docs/users/GUARDRAILS.md`
- Example app: `apps/example`

## When Headless is overkill

- You ship one small app with default Material widgets.
- You do not need keyboard/a11y or overlay-heavy components.
- You do not plan to customize visuals or reuse components across brands.
