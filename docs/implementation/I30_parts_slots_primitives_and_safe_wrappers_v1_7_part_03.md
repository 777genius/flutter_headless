## I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7) (part 3)

Back: [Index](./I30_parts_slots_primitives_and_safe_wrappers_v1_7.md)

## Track B — Safe wrappers for full takeover

### B0) What “safe” means (concrete guarantees)

For a wrapper to be worth it, it must guarantee at least:

1) **Close contract correctness** for overlay content (dropdown menu).
2) **Command wiring** remains correct by default.
3) **No new activation path** is introduced by the default skeleton.
4) **Debug-only diagnostics** make violations obvious.

---

### B0.1 Debug diagnostics scope (minimal, low-risk)

We keep debug checks narrow to avoid false positives:

- Safe wrapper skeleton must not add activation handlers (no `onTap`, `onPressed` on roots).
- Overlay close contract is handled by the safe wrapper itself (when it animates exit).
- Engine fail-safe already covers “close contract timeout”; wrappers should make it rare.

We do not attempt to automatically detect gestures deep in the subtree.

---

### B1) Dropdown: Safe renderer builder (highest ROI)

Dropdown is the easiest place to misuse:
- overlay lifecycle,
- close contract,
- item semantics.

Proposed API shape (aligned with MVP below):

- `SafeDropdownRenderer` (generic) that takes a set of builder functions:
  - required: `buildTrigger`, `buildMenuSurface`, `buildItem`
  - optional: `buildItemContent`, `buildEmptyState`, `buildChevron`
and internally:
  - wraps the menu in a close-contract runner,
  - ensures `commands.selectIndex` is the tap handler for the default item,
  - preserves semantics defaults.

Key idea:
- Most users never implement `RDropdownButtonRenderer` directly.
- They implement “how it looks” builders and use safe skeleton behavior.

Where to place it:
- Core scaffold: `headless_contracts`
- Optional ergonomic facade: `headless_theme`

#### B1.1 SafeDropdownRenderer — MVP scope (to prevent scope creep)

**Goal of MVP**: enable a fully custom dropdown renderer without breaking:
activation policy, close contract, and basic item semantics.

##### Required inputs (must)

- `buildTrigger(...)`
  - Renders the trigger visuals (no activation handlers).
  - Receives: spec, state, selected item model (nullable), plus a `defaultChild` so that
    even “full takeover” can remain Decorate-first when desired.
- `buildMenuSurface(...)`
  - Renders the menu container/surface.
  - Must receive: `child` (menu content), tokens/values it needs, and overlay phase if
    it wants to animate (but close contract is handled by the scaffold).
- `buildItem(...)` (single item row)
  - Renders one selectable row.
  - Receives: item model, index, selection/highlight state, and `onSelect` callback
    that is already wired to `commands.selectIndex(index)` by the scaffold.

##### Optional inputs (nice-to-have)

- `buildItemContent(...)`
  - For richer item layout without replacing the whole row.
- `buildEmptyState(...)`
  - For empty lists.
- `buildChevron(...)`
  - If trigger chevron should be customized independently.

##### What the scaffold guarantees (the “safe” part)

- **Close contract**:
  - When `overlayPhase == closing`, scaffold ensures `commands.completeClose()` is called
    after exit animation completes (internally via `CloseContractRunner`).
- **Command wiring**:
  - Default selection uses the provided `onSelect` callback (already safe-wired).
- **No activation path added by default**:
  - Scaffold itself does not add `onTap` handlers on trigger/menu surfaces.
  - Component remains the activation owner.
- **Minimal semantics**:
  - Scaffold provides the baseline semantics wrapping for menu items:
    `selected`, `enabled`, `label` (derived from item model).
  - Custom item widgets can add local semantics, but must not introduce activation.

##### Non-goals for MVP

- No “detect user gestures in subtree”.
- No full layout system for complex headers/footers in menu (can be added later via slots).
- No animation customization API beyond “provide a widget child”; animation policies stay
  in presets or in explicit user widgets.

---

### B2) Button + Checkbox: safe renderer scaffolds (lower ROI than dropdown)

Button and checkbox have fewer lifecycle pitfalls, but still have a common misuse:
renderer adding its own tap handlers.

Safe builder scaffolds can help by:
- providing “surface + content” composition primitives,
- documenting “do not add onTap” as a hard rule,
- optionally adding debug-only assertions via a shared helper.

---

## Open questions (important forks)

Breaking is allowed, but we must not keep legacy parallel APIs.

## Execution plan (one big PR, no legacy)

### Phase 1 — Introduce new surfaces (compile green)

1) `headless_material`: create public primitives layer (`lib/primitives/*` + `primitives.dart`).
2) Update Material preset renderers to import primitives via `package:headless_material/primitives.dart`.
3) `headless_contracts`: introduce SlotOverride-based slots + typed contexts for:
   - Button
   - Checkbox
   - CheckboxListTile

### Phase 2 — Wire through components (behavior unchanged)

4) Update components to pass the new SlotOverride-based slots in their render requests.
5) Update preset renderers to apply new slots (Decorate-first).

### Phase 3 — Safe wrappers (dropdown first)

6) Implement `SafeDropdownRenderer` scaffold in `headless_contracts`.
7) Provide at least one dogfooded usage path:
   - either a Material preset implementation using the scaffold,
   - or an example/cookbook recipe demonstrating a real custom renderer built safely.

### Phase 4 — Cleanup (no legacy)

8) Remove the old slot APIs that were replaced (no “V1 + V2” coexistence).
9) Ensure docs do not suggest importing internal `src/*` primitives.

---

## One big PR checklist (must pass)

- **Public API**
  - No `V1 + V2` slot types living side-by-side after merge.
  - All public primitives are under `headless_material/lib/primitives/*`.
  - Presets do not import `src/primitives/*` directly.
- **Behavior / invariants**
  - No renderer introduces activation handlers on roots (keep single activation source).
  - Dropdown close contract remains correct (no missing `completeClose()`).
- **Docs**
  - Cookbook examples show Decorate-first patterns for slots.
  - Docs do not reference internal paths.
- **Tests**
  - `melos run analyze`
  - `melos run test`

---

## Post-implementation gap analysis (what still blocks a 9.5–10/10)

After implementing v1.7, assume the iteration is **not done** until the misuse risks are structurally removed
and guarded by conformance tests.

### Ownership matrix (make invariants enforceable)

This is the contract we want. If any implementation violates it, we treat it as a bug.

| Concern | Owner | Allowed helpers | Must NOT be owned by |
|---|---|---|---|
| Trigger activation (tap/keyboard) | **Component** | Pressable/foundation controllers | Primitives, menu items |
| Selection triggering (`selectIndex`) | **Safe scaffold / component** | Commands object | User item widgets |
| Overlay close contract (`completeClose`) | **Safe scaffold / renderer** | `CloseContractRunner` | Primitives |
| Component semantics (“button”, “selected”, “enabled”) | **Component / scaffold baseline** | local semantics where safe | Primitives owning `onTap` |

### G1) Public primitives accidentally own interaction (violates the primitives contract)

Problem:
- Some public primitives currently include `onTap` / gesture handling.
- That violates the “visual-only by default” rule and risks:
  - reintroducing a second activation path,
  - freezing behavior decisions as public API,
  - making it hard to reason about the ownership matrix above.

Fix (required):
- Split **two categories** and enforce naming + export rules:

1) **Visual primitives (public)**:
   - boring, visual-only building blocks,
   - do not own activation, do not own close contracts, do not own component semantics.

2) **Preset composition widgets (internal by default)**:
   - can wire gestures/press effects as part of a preset renderer implementation,
   - remain in `src/*` unless there is a proven need to make them public.

Rule:
- If a widget *needs* `onTap` to be useful, it is almost never a public primitive.
- If we still need an interactive public surface, it must be explicitly named as such
  and documented with a “ownership model” section (rare exception, not the default).

### G2) SafeDropdownRenderer is not “structurally safe” against double-select yet

Problem:
- If the safe scaffold exposes a selection callback and also wires selection on the outside,
  user code can accidentally trigger selection twice.

Fix (required):
- Make the scaffold the **single owner of selection triggering**.
- Builders must be visual. Users should not need (or be encouraged) to call selection.

Target behavior:
- A user activation results in **exactly one** `commands.selectIndex(index)` call.
- Disabled items must never trigger selection.

---

