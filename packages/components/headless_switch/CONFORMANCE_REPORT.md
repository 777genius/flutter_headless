# Conformance Report: headless_switch

## Overview

This package provides `RSwitch` and `RSwitchListTile` components following the headless UI pattern.

## Test Coverage

Tests are located in:
- `test/r_switch_test.dart`
- `test/r_switch_list_tile_test.dart`

## Conformance Status

| ID | Requirement | Status |
|----|-------------|--------|
| T1 | Semantics: toggled/enabled/label | ✅ Pass |
| T2 | Tap/Space/Enter → onChanged called with toggled value | ✅ Pass |
| T3 | Disabled: onChanged==null → no activation | ✅ Pass |
| T4 | Missing capability → MissingCapabilityException | ✅ Pass |
| T5 | Style sugar → overrides flow | ✅ Pass |
| T6 | thumbIcon param wins over style.thumbIcon (POLA) | ✅ Pass |
| T7 | ListTile semantics | ✅ Pass |
| T8 | ListTile activation (tap/keyboard) | ✅ Pass |
| T9 | Token resolver receives WidgetState.selected | ✅ Pass |
| T10 | Slots passed to renderer (RSwitch) | ✅ Pass |
| T11 | Slots passed to renderer (RSwitchListTile) | ✅ Pass |
| T12 | Drag: tap coexists with drag gesture | ✅ Pass |
| T13 | Drag: horizontal fling toggles switch (off→on, on→off) | ✅ Pass |
| T14 | Drag: disabled prevents drag activation | ✅ Pass |
| T15 | Drag: high velocity fling toggles regardless of position | ✅ Pass |
| T16 | Drag: RTL direction works correctly | ✅ Pass |
| T17 | Drag: dragStartBehavior spec is passed to renderer | ✅ Pass |
| T18 | ListTile: HeadlessPressableSurfaceFactory capability wrapper used | ✅ Pass |
| T19 | ListTile: fallback to HeadlessPressableRegion when capability absent | ✅ Pass |

## I33 Implementation Details

### Drag Thumb Support (Part B)
- `RSwitchState` extended with `dragT` (0..1 position) and `dragVisualValue` (preview)
- `RSwitchSpec` extended with `dragStartBehavior`
- Pure functions in `logic/switch_drag_decider.dart` for velocity threshold and RTL
- Material/Cupertino renderers interpolate colors/alignment during drag

### Pressable Surface Capability (Part A)
- `HeadlessPressableSurfaceFactory` capability interface
- Material: `MaterialInkPressableSurface` with `InkResponse` for ripple
- Cupertino: `CupertinoPressableSurface` with opacity feedback
- `RSwitchListTile` uses capability wrapper (single activation source)

## Verification

```bash
cd packages/components/headless_switch
flutter test
```

All tests passing as of 2026-01-19.

## References

- `docs/SPEC_V1.md` - Component specification
- `docs/CONFORMANCE.md` - Conformance guidelines
