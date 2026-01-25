# Cookbook — Advanced recipes

These recipes are useful when you are wiring presets into a large app.

## Scoped overrides

Use `Headless*Scope` to replace renderers in a subtree.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class EmptyButtonRenderer implements RButtonRenderer {
  @override
  Widget render(RButtonRenderRequest request) => const SizedBox();
}

class EmptyDropdownRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) => const SizedBox();
}

class EmptyTextFieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) => const SizedBox();
}

class ScopedOverridesExample extends StatelessWidget {
  const ScopedOverridesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HeadlessButtonScope(
      renderer: EmptyButtonRenderer(),
      child: HeadlessDropdownScope(
        renderer: EmptyDropdownRenderer(),
        child: HeadlessTextFieldScope(
          renderer: EmptyTextFieldRenderer(),
          child: const Placeholder(),
        ),
      ),
    );
  }
}
```

## Material theme defaults

Set brand-level defaults once and keep per-instance overrides optional.

```dart
import 'package:flutter/widgets.dart';
import 'package:headless/headless.dart';
import 'package:headless_theme/headless_theme.dart';

class AppWithDefaults extends StatelessWidget {
  const AppWithDefaults({super.key});

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeProvider(
      theme: MaterialHeadlessTheme(
        defaults: MaterialHeadlessDefaults(
          button: MaterialButtonOverrides(
            density: MaterialComponentDensity.compact,
            cornerStyle: MaterialCornerStyle.rounded,
          ),
          dropdown: MaterialDropdownOverrides(
            density: MaterialComponentDensity.compact,
            cornerStyle: MaterialCornerStyle.rounded,
          ),
        ),
      ),
      child: const Placeholder(),
    );
  }
}
```

