# headless_example

Demo app for the Headless component architecture.

## What this app demonstrates

- A shared header that switches between Material and Cupertino headless themes
- Light and dark theme toggles in the example shell
- Global `AnchoredOverlayEngineHost` for overlay-based components like Dropdown
- Example screens for the current component set:
  - Button
  - Dropdown
  - Autocomplete
  - TextField
  - Phone field
  - Pinput
  - Switch
  - Glassmorphism
  - Intentional errors
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
