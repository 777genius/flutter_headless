## I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7) (part 4)

Back: [Index](./I30_parts_slots_primitives_and_safe_wrappers_v1_7.md)

## “Finish to 9.5–10/10” — completion plan (architectural, no scope creep)

This is the follow-up plan that closes the gaps above without expanding MVP.

### Milestones (tight and verifiable)

- **M0 — Contract audit (1 short PR section)**:
  - Document the ownership matrix for Dropdown/Button/Checkbox (this section).
  - Audit current exports to find violations (interactive primitives, selection callbacks).
- **M1 — Primitives contract enforcement**:
  - Convert exported primitives to visual-only.
  - Move interaction wiring to preset composition (internal).
  - Add minimal dartdoc examples for each exported primitive.
- **M2 — SafeDropdownRenderer API hardening**:
  - Adjust API so selection cannot be double-triggered by design.
  - Keep MVP scope unchanged.
- **M3 — Conformance tests as guardrails**:
  - Add the minimal set of high-ROI tests below.
  - Ensure tests validate invariants, not visuals.
- **M4 — Docs refresh (tiny, but decisive)**:
  - Cookbook recipes show Decorate-first customization with primitives.
  - SafeDropdown docs explicitly state “builders are visual; scaffold owns selection”.

### M0 audit findings (current codebase)

This section is intentionally concrete: it lists violations with file paths so we can close them
without guesswork.

#### F1) Public primitive owns gesture handling (must be made visual-only)

Found:
- `packages/headless_material/lib/primitives/material_menu_item.dart`
  - uses `GestureDetector` and exposes `onTap`.

Why this is a problem:
- Violates the primitives contract (“visual-only by default”).
- Makes it too easy to introduce a second activation path and freezes interaction behavior as API.

Planned fix:
- Replace with a **visual-only** primitive:
  - `MaterialMenuItem` (public) takes only layout/decoration inputs + `child`.
- Move interaction wiring to preset renderer composition (internal), e.g.:
  - internal `src/.../material_menu_item_tap_region.dart` (or equivalent) that wraps the visual primitive.

Acceptance test for the fix:
- Grep in `headless_material/lib/primitives/*` finds no gesture ownership (`GestureDetector`, `InkWell`, `onTap`, `onPressed`).

#### F2) SafeDropdownRenderer exposes selection callback to builders (double-select risk)

Found:
- `packages/headless_contracts/lib/src/renderers/dropdown/safe_dropdown_contexts.dart`
  - `SafeDropdownItemContext` includes `onSelect`.
- `packages/headless_contracts/lib/src/renderers/dropdown/safe_dropdown_renderer.dart`
  - scaffold wires an outer tap to `commands.selectIndex(index)` AND also passes `onSelect` to `buildItem`.

Why this is a problem:
- Users can (accidentally) call `onSelect` inside `buildItem` and also get the outer tap,
  causing selection twice.
- This contradicts the “safe by design” goal; safe wrapper must make the safe path hard to misuse.

Planned fix:
- Remove `onSelect` from `SafeDropdownItemContext`.
- Make `buildItem(...)` visual-only:
  - it should receive item state + `child` (default row/content),
  - scaffold owns selection and wraps the row with semantics + a single tap handler.

Acceptance tests for the fix:
- Conformance test proves: one user tap triggers `commands.selectIndex` exactly once.
- Disabled items never select.

### P1) Primitives: enforce “visual-only by default” without freezing UI decisions

Deliverables:
- Audit every symbol exported from `headless_material/lib/primitives.dart`.
- For each exported primitive:
  - no `onTap` / `onPressed` / `GestureDetector` / `InkWell` / `Semantics(onTap:)`,
  - narrow inputs (colors/radius/padding/duration),
  - at least one copy-paste example in dartdoc (or cookbook if longer).

Implementation steps:
1) Identify exported primitives that currently own interaction.
2) For each:
   - extract a *visual-only* widget (keep public),
   - keep interaction wiring inside renderer composition (internal),
   - update preset renderers to use visual primitives + internal wiring.
3) Add a short “Primitives contract” section to user docs:
   - what primitives are for,
   - what they deliberately do not do.

Acceptance criteria:
- Public primitives are safe to use inside slot overrides without risking double activation.
- Presets still render the same behavior.

### P2) SafeDropdownRenderer: API that is safe by design (selection ownership)

Goal:
- keep MVP (no menu headers/footers/layout DSL),
- but make misuse (double select) structurally hard.

Contract change (breaking inside v1.x is OK):
- `buildItem(...)` becomes **visual-only**.
- Scaffold owns selection and wraps the item row:
  - provides baseline semantics (`selected`, `enabled`, `label`),
  - wires the tap/activation once and calls `commands.selectIndex(index)`.

API sketch (illustrative):
- `buildItem(ctx)` gets:
  - item model + selection/highlight flags,
  - `child` (default content row),
  - **no** `onSelect`.

Debug guardrail:
- Dartdoc on `buildItem`: “Do not add tap handlers inside menu items; scaffold owns selection.”

Acceptance criteria:
- Conformance test proves a tap triggers `commands.selectIndex` exactly once.
- Disabled items never trigger selection.
- Close contract completion remains correct (after exit duration).

### P3) Minimum conformance tests (high ROI, non-negotiable)

Prefer conformance tests in `packages/headless_test/` when feasible so presets and user renderers can be validated
consistently. Keep tests focused on invariants, not visuals.

- **Button**
  - Decorate slot wraps default surface without affecting activation ownership.
  - Replace works, and docs make explicit what is “advanced / unsafe if misused”.
- **Checkbox**
  - Mark slot can be decorated without losing selected/disabled semantics.
- **CheckboxListTile**
  - Tile slot can Decorate default ListTile without changing onTap ownership.
- **SafeDropdownRenderer**
  - When overlay enters `closing`, scaffold completes close after exit animation (no timeout).
  - Tap triggers `commands.selectIndex` exactly once (no double invoke).

### Review checklist (use during PR review)

- **Primitives**
  - Public exports have no gesture ownership.
  - Public exports have minimal dartdoc + a copy-paste example.
  - Presets dogfood primitives exclusively via `package:headless_material/primitives.dart`.
- **SafeDropdownRenderer**
  - No selection callback is exposed to builders.
  - Item semantics are present and correct by default.
  - Disabled items cannot select.
  - Close contract is guaranteed even under disposal while closing.
- **Slots**
  - Decorate-first usage is ergonomic.
  - Replace remains possible but clearly documented as advanced.

---

## Definition of Done (top-level)

- Dropdown customization can be done via slots + primitives without writing a renderer.
- Safe dropdown wrapper exists and covers close contract by default.
- Button/Checkbox have SlotOverride-based parts with no legacy parallel APIs kept around.
- Cookbook includes “safe customization” examples (Decorate-first).
- Conformance/docs clearly state invariants and misuse patterns.

### Non-functional DoD

- No new “mega files” (files ≤ 300 lines).
- New public surfaces have short dartdoc + at least one copy-paste example each.
- SafeDropdownRenderer does not expose selection callbacks in builders (scaffold is the single owner).
- Public primitives exported by `headless_material` are visual-only by default (no gesture ownership).

