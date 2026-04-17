## Headless docs (English)

These docs are split for users and contributors. The Russian docs are internal
design notes from prototyping.

### Entry points

- Users Guide: `docs/users/README.md`
- Users Cookbook: `docs/users/COOKBOOK.md`
- Contributors: `docs/contributors/README.md`

### 30-second quickstart (Material)

```dart
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessMaterialApp(home: Placeholder()));
}
```

### Quickstart (Cupertino)

```dart
import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

void main() {
  runApp(const HeadlessCupertinoApp(home: Placeholder()));
}
```

### Most common recipes

- One-screen quick start: `docs/users/README.md#one-screen-quick-start`
- Button styling: `docs/users/COOKBOOK.md#button-style`
- Button slots: `docs/users/COOKBOOK.md#button-slots-decorate-surface`
- Dropdown with items: `docs/users/COOKBOOK.md#dropdown-with-items`
- Dropdown menu style: `docs/users/COOKBOOK.md#dropdown-menu-style-simple`
- Dropdown menu surface: `docs/users/COOKBOOK.md#dropdown-menu-surface-wrap-structure`
- TextField controlled vs controller: `docs/users/COOKBOOK_TEXTFIELD.md`
- Autocomplete: `docs/users/COOKBOOK_AUTOCOMPLETE.md`
- Advanced recipes (scopes + defaults): `docs/users/COOKBOOK_ADVANCED.md`
- Guardrails: `docs/users/GUARDRAILS.md`

### Examples

- Demo app: `apps/example`
- Example screens: `docs/users/README.md#example-screens-code`

### References (optional)

- Architecture: `docs/ARCHITECTURE.md`
- V1 decisions: `docs/V1_DECISIONS.md`
- Spec: `docs/SPEC_V1.md`
- Conformance: `docs/CONFORMANCE.md`
