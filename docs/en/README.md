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
- Dropdown with items: `docs/users/COOKBOOK.md#dropdown-with-items`
- TextField controlled vs controller: `docs/users/COOKBOOK.md#textfield-controlled-vs-controller`
- Autocomplete: `docs/users/COOKBOOK.md#autocomplete`
- Scoped overrides: `docs/users/COOKBOOK.md#scoped-overrides`
- Theme defaults (Material): `docs/users/COOKBOOK.md#material-theme-defaults`

### Examples

- Demo app: `apps/example`

### References (optional)

- Architecture: `docs/ARCHITECTURE.md`
- V1 decisions: `docs/V1_DECISIONS.md`
- Spec: `docs/SPEC_V1.md`
- Conformance: `docs/CONFORMANCE.md`
