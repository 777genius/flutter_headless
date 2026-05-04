# Headless 1.1.0 Release Notes

## Summary

Headless 1.1.0 is a lockstep release for the published package set after
`1.0.0`. It promotes the post-1.0 fixes and polish currently on `main` to
pub.dev.

## Highlights

- `RTextField` now exposes `enableIMEPersonalizedLearning` and `autofillHints`.
- Autocomplete restores input focus and caret after selection and adds focused
  regression coverage for anchor geometry, pointer taps, and selection caret
  behavior.
- Material and Cupertino dropdown/textfield renderers receive layout, focus, and
  menu sizing refinements.
- Overlay content clamps menu width to the available viewport instead of
  overflowing narrow screens.
- `headless_test` semantics helpers are compatible with current Flutter
  semantics flag shapes.
- Example and docs-site coverage now includes richer autocomplete/dropdown
  parity showcases plus phone and PIN input experiments.

## Release Set

- `anchored_overlay_engine`
- `headless_tokens`
- `headless_foundation`
- `headless_contracts`
- `headless_theme`
- `headless_adaptive`
- `headless_material`
- `headless_cupertino`
- `headless_test`
- `headless`
- `headless_button`
- `headless_checkbox`
- `headless_switch`
- `headless_dropdown_button`
- `headless_textfield`
- `headless_autocomplete`

## Notes

- `apps/example` and `tools/headless_cli` remain non-published workspace
  projects.
- `headless_phone_field` and `headless_pinput` remain example-local packages.
- `liquid_glass_apple` remains outside the Headless 1.1 release wave.
