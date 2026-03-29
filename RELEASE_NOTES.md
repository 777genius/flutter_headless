# Headless 1.0.0 Release Notes

## Summary

Headless 1.0.0 promotes the monorepo from an internal pre-release workspace to
an externally releasable package ecosystem.

## Highlights

- Lockstep `1.0.0` versions across the Headless release set.
- Release metadata added for every published package.
- Dedicated release guardrails, dry-run publishing, and integration/golden
  release lanes.
- Known skipped release blockers removed from generated scaffolds and example
  coverage.

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
- `liquid_glass_apple` remains outside the Headless 1.0 release wave.
