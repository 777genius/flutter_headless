# anchored_overlay_engine

Anchored overlay engine for Flutter: lifecycle, policies, and positioning without
Material/Cupertino dependencies.

This package is an engine/runtime, not a UI component library.

## Positioning on pub.dev (short)

`anchored_overlay_engine` is an engine, not “yet another dropdown/tooltip”.
It solves system-level overlay concerns:

- predictable lifecycle (`opening/open/closing/closed`) and close contract,
- deterministic policies (dismiss/focus/reposition),
- anchored positioning (flip/shift/maxHeight + safe area + keyboard),
- insertion via Flutter primitives (`OverlayPortal`).

If you are looking for ready-made UI widgets, this is not it.
If you need a reliable overlay runtime for your own design system, it is.

## Requirements

- Flutter >= 3.10 (OverlayPortal).

