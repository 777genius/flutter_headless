# headless_foundation

Shared behavior primitives for Headless components.

This package contains the non-visual runtime used across the ecosystem:

- focus and interaction handling
- listbox and option behavior
- finite-state helpers
- overlay coordination built on `anchored_overlay_engine`

Use `headless_foundation` when building custom headless components or when you
need the lower-level behavior layer without pulling the facade package.
