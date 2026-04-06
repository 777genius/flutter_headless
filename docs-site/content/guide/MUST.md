### P0: "Landing" for real production use (so it doesn't look like over-engineering)

P0 Goal: so that a regular user can **quickly integrate** and get "almost like Material/Cupertino" without creating their own renderers from scratch, while preserving headless contracts and the ability to swap visuals.

- **P0.1 — Preset packages (Material first)**
  - `headless_material` (or equivalent): implementation of renderers + token resolvers for Button/Dropdown (minimum v1).
  - Support for **per-instance customization** via contractual overrides (see `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`).
  - Advanced branch: ability to pass preset-specific overrides (Material/Cupertino) without coupling to core.

- **P0.2 — "Quick start" in `apps/example`**
  - example not with test renderers, but with a real preset (Material v1),
  - show 3 scenarios: default / per-instance overrides / slot override.

- **P0.3 — Conformance as a product guarantee (I10)**
  - `CONFORMANCE_REPORT.md` for `headless_button` and `headless_dropdown_button`,
  - CI check for report presence where "passes conformance" is claimed.

- **P0.4 — Limit v1 to avoid bloating contracts**
  - don't drag 100 Material/Cupertino parameters into core components,
  - extensions only additively, and "power" through overrides/slots/scoped theme.

---

### Improvements that will genuinely enhance "headless" (rated on a 10-point scale)
Below **score = ROI** (how "worth doing": benefit/universality/longevity relative to complexity).

- **1) Extract rendering from `R*` into a "renderer contract" (true headless) — 9/10**
  - **Why**: if `RTextButton` defines the structure (Container/Row/loader), this limits brands. Better: behavior/states -> *renderer*, which decides structure, effects, primitives (Ink/Material/gradients/shapes).
  - **What to borrow from the world**: React Aria "parts + slots + contexts", Ark UI "unstyled parts".

- **2) Parts/Slots API for every complex component — 8/10**
  - **Why**: `Dialog/Select/DatePicker` almost always require "anatomy" (`Root/Trigger/Content/...`) so that design can change structure without forking.
  - **Result**: composition instead of monolith, less "copyWith hell".

- **3) Real Interface Segregation for the theme (minimal contract + capability composition) — 9/10**
  - **Why**: `RenderlessTheme` with dozens of `resolveX` will quickly become a source of breaking changes.
  - **Solution**: separate `ButtonResolver/InputResolver/...` + aggregator with defaults/adapters; themes are assembled compositionally.

- **4) Controllability as in Downshift: controlled/uncontrolled + "transition interception" (`stateReducer` analog) — 7/10**
  - **Why**: product "exceptions" will inevitably appear (don't close menu on selection, custom focus rules, etc.).
  - **Effect**: extensions without forks, predictable customizations.

- **5) Unified "state resolution" layer (state priorities) — 8/10**
  - **Why**: `Set<WidgetState>` by itself doesn't define combination priorities. Without explicit rules there will be unexpected bugs.
  - **How**: a rule map/matrix (like the `FWidgetStateMap` idea), where order/specificity is defined explicitly.

- **6) FSM (finite state machines) for complex interactive patterns — 8/10**
  - **Why**: `Select/Menu/Combobox` break at edges (focus, keyboard, closing, nested overlays). FSM dramatically reduces "accidental" bugs.
  - **What to borrow**: Ark UI/Zag.js conceptually (exact port not required).

- **7) Overlay/Popover infrastructure as a separate module (positioning/scroll strategies) — 7/10**
  - **Why**: dialogs/menus/tooltips should share one powerful layer.  
  - **What to borrow**: Angular CDK Overlay (OverlayRef + strategies), Floating UI (the "middleware" pipeline is conceptually useful).

- **8) Semantic tokens on top of "raw" tokens (semantic tokens) — 7/10**
  - **Why**: brands change not by "primary=purple", but by "actionPrimaryBg", "dangerFg", "surfaceRaisedBg".  
  - **Effect**: multi-brand becomes easier, fewer cascading edits.

- **9) API stability policy + contract versioning — 8/10**
  - **Why**: a design system is a library. Its pain point is breaking users.
  - **How**: capability discovery/optional resolvers/adapters/default implementations.

- **10) Testing strategy at the "behavior + a11y" level (not golden UI) — 7/10**
  - **Why**: in headless, correctness of events/focus/semantics matters more than pixels.
  - **What to test**: state transitions, focus trap, keyboard scenarios, semantics.

---

### Additions from recent research (2025-2026)

- **11) Focus management as a first-class mechanism (trap/restore/close button) — 9/10**
  - **Why**: this is the main source of critical bugs (keyboard trap, focus on hidden elements, broken announcements).
  - **How**: common mechanism in `headless_foundation` + requirements in `docs/V1_DECISIONS.md`.

- **12) WCAG 2.2 baseline (Target Size 24x24, Focus Not Obscured/ensureVisible) — 8/10**
  - **Why**: compliance since 2025, better to have baseline guarantees by default.

- **13) W3C Design Tokens 2025.10 import (CLI) — 8/10**
  - **Why**: standard format -> easier multi-brand and integration with Figma/Tools.
  - **How**: CLI command like `headless tokens import design-tokens.json` (to be implemented later), support for `$extends` as brand inheritance.

- **14) Context splitting policy (avoid re-render storms) — 8/10**
  - **Why**: on large trees "context value per build" kills perf.
  - **How**: `ValueListenable`/`InheritedNotifier` and splitting contexts by meaning (open/highlight/positioning).

- **15) Animations as first-class (enter/exit + overlay closing phase) — 9/10**
  - **Why**: a typical headless UI problem is that exit animations break when the subtree is removed "immediately".
  - **How**: the overlay mechanism should support a "closing phase" (keep subtree until exit completes), and renderer contracts should accept a motion policy (durations/easing).

- **16) AI/MCP metadata (LLM.txt) for correct component usage by agents — 8.5/10**
  - **Why**: UI generation without invariants leads to inconsistency and bugs; metadata + docs dramatically increase the chance of correct usage.
  - **How**: keep a short `LLM.txt` (or equivalent document) in each package, describing invariants, extension points, examples of correct usage.

- **17) a11y test helpers + manual checks (automation 30-50%) — 8.5/10**
  - **Why**: automation catches only a portion of problems; without helpers, tests will be irregular and incomplete.
  - **How**: add test matchers/assertions for semantics/focus/keyboard and establish a manual checklist (VoiceOver/NVDA/keyboard).

- **18) Unified press events (like "usePress", but Flutter-style) — 8.5/10**
  - **Why**: presses come from different sources (mouse/touch/keyboard/assistive tech), and without a unified policy `pressed` will "stick"/break at edges.
  - **How**: common mechanism in `headless_foundation/interactions` (press events + pointerType + cancel/drag-off semantics), used by all `R*`.

- **19) Positioning middleware pipeline (Floating UI-style) — 8.5/10**
  - **Why**: stable overlay positioning requires rule composition (offset/flip/shift/arrow) and auto-updating on scroll/resize/layout.
  - **How**: typed middleware in `anchored_overlay_engine/positioning` + coalescing updates to 1/frame (perf guardrail).

---

### Approaches/principles you mentioned (and how they map to Headless)
- **Composition > Inheritance — 10/10**
  - This is literally the foundation of headless: behavior/render/tokens/variants are assembled "like building blocks".  
  - In practice: less `BaseTheme extends ...`, more "theme = composition of resolvers/tokens/policies".

- **Principle of Least Astonishment (POLA) — 9/10**
  - In headless this is critical: the API should behave "as the Flutter developer expects".
  - POLA rules that are especially important:
    - predictable defaults (disabled/loading/focus),
    - stable names and roles (variant/size/state),
    - minimal "magic" side effects (don't close/change focus without reason),
    - unified controlled/uncontrolled model.

---

### If choosing the 3 "most impactful" improvements in your context
1) **Renderer contract (true headless)** — 9/10  
2) **Segregated theme contract + resolver composition** — 9/10  
3) **Parts/Slots API for complex components** — 8/10  

Tell me your priority: **maximum flexibility for brands** or **speed of releasing a component set** — and I'll propose a "target" architecture (minimal set of contracts + layout by modules/packages).
