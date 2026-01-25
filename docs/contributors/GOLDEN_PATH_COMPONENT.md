# Golden Path: Add a Component

This guide describes the minimal, repeatable path to add a new component.

## 1) Generate a skeleton

```bash
dart run tools/headless_cli/bin/renderless.dart generate component <name>
```

This creates a new package under `packages/components/headless_<name>`.

## 2) Add contracts

Create contract types in `packages/headless_contracts`:
- renderer interface
- token resolver interface
- overrides type
- slots type
- render request + spec + state

Export new contracts from the relevant `renderers.dart`/`slots.dart` files.

## 3) Implement the component

In `packages/components/headless_<name>`:
- implement behavior + a11y in the component widget
- integrate `style` sugar and `RenderOverrides`
- add unit and conformance tests

## 4) Implement presets

In `packages/headless_material` and/or `packages/headless_cupertino`:
- renderer implementation
- token resolver implementation
- preset-specific overrides (optional)

## 5) Document and verify

- update README and LLM.txt in the component package
- update `CONFORMANCE_REPORT.md`
- run `flutter test` in affected packages

## Notes: file size limits

For production code, keep files small and focused.

For **tests**, it's acceptable for a single file to exceed typical size limits when it improves readability and keeps related scenarios together. Prefer splitting only when it becomes hard to navigate or review.
