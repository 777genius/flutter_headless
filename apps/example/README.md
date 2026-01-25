# headless_example

Demo app for the Headless component architecture.

## What this app demonstrates

- Material preset (`MaterialHeadlessTheme`)
- Global `AnchoredOverlayEngineHost` for overlay-based components (Dropdown)
- Customization layers:
  - default preset
  - per-instance token overrides (`RenderOverrides`)
  - slots (structural customization)
  - scoped theme (`HeadlessThemeProvider` on a subtree)

## Run

```bash
cd apps/example
flutter run
```

## Docs

- `docs/SPEC_V1.md`
- `docs/CONFORMANCE.md`
- `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
