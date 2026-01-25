## I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7) (part 2)

Back: [Index](./I30_parts_slots_primitives_and_safe_wrappers_v1_7.md)

## Track A — Parts/Slots + Primitives

### A0) Slot policy to reduce misuse (recommended defaults)

We already have `SlotOverride` with `Replace/Decorate/Enhance` in `headless_contracts`.

Policy v1.7:
- Prefer **Decorate** for most customization.
- Use **Replace** only when you can preserve:
  - command wiring (`commands.selectIndex`, `commands.completeClose`, etc),
  - semantics state (`selected`, `enabled`),
  - close contract (overlay animations).

We will make this policy visible in docs and cookbook, and reinforce it with safe wrappers (Track B).

---

### A1) Dropdown (`RDropdownButton<T>`) — extend what already works

Current state:
- Dropdown already has `RDropdownButtonSlots` with typed contexts and `SlotOverride`.
- Material preset already uses primitives: `MaterialMenuSurface`, `MaterialMenuItem`,
  `MaterialPressableOverlay`, and a dedicated close contract widget.

What we should improve (useful, not YAGNI):

#### A1.1 Add missing “primitives surface area” (export + intended usage)

Today primitives exist under `headless_material/lib/src/primitives/*`.

Plan:
- Introduce a dedicated public layer inside `headless_material`:
  - `lib/primitives/*` (public, documented, stable)
  - `lib/primitives.dart` (exports)
  - `src/primitives/*` becomes either removed (preferred) or strictly internal
- Move/replace the current primitives into the public layer:
  - `MaterialMenuSurface`
  - `MaterialMenuItem`
  - `MaterialSurface`
  - `MaterialPressableOverlay`
- Make `headless_material` renderers depend on public primitives (dogfooding).
- Add “recommended usage” snippets in user docs (cookbook) showing:
  - customizing `menuSurface` via `Decorate` and reusing `MaterialMenuSurface`
  - customizing `itemContent` via `Decorate` while keeping default `commands.selectIndex`

Why this matters:
- Users can customize safely without needing to re-implement the renderer.
- We avoid freezing internal implementation details as “public API by accident”.

#### A1.1.1 Public primitives layout (concrete)

In `headless_material`:

- `lib/primitives.dart` (public exports)
- `lib/primitives/`
  - `material_menu_surface.dart`
  - `material_menu_item.dart`
  - `material_surface.dart`
  - `material_pressable_overlay.dart`
  - `material_button_surface.dart` (new)

Implementation rules:
- Preset renderers import primitives only via `package:headless_material/primitives.dart`.
- Docs must not suggest importing internal `src/*` symbols.

#### A1.1.2 Public primitives design rules (to avoid freezing UI decisions)

Public primitives must be intentionally narrow:

- **Visual-only by default**
  - No ownership of activation (no `onTap` / `onPressed` on primitives that are meant to be
    used as renderer roots).
  - If a primitive needs interaction (rare), it must be clearly labeled as such and must not
    violate “single activation source”.
- **No overlay lifecycle policy**
  - Primitives must not manage `OverlayHandle` / close contract logic.
  - Close contract remains a renderer/safe-wrapper responsibility.
- **No semantics ownership**
  - Do not put component-level semantics (“button”, “selected”, “toggled”) into primitives.
  - Component owns semantics; renderer may add local semantics only when it cannot cause
    double activation.
- **Stable inputs**
  - Prefer plain value inputs (colors, radius, padding, duration) rather than implicit reads
    from Theme/MediaQuery where possible.
  - If Theme access is needed (e.g. platform density), keep it explicit and documented.
- **Dogfood requirement**
  - Material preset renderers must use these primitives. If a primitive is not used by the
    preset, it should not be public.

#### A1.2 Slot coverage: only add what solves real customization needs

We should not explode slots. Start with a small set of high-ROI additions:

- **Trigger**
  - Keep `anchor` as the “big lever”.
  - Ensure `chevron` remains the “small lever”.
  - Consider adding a *single* slot that targets trigger content row
    (text + chevron) if real use-cases show up.

- **Menu**
  - `menuSurface` already exists and is a good lever.
  - `item` and `itemContent` cover the biggest customization needs.
  - `emptyState` exists.

Do not add more until there are real user requests.

#### A1.3 Guidance for multi-select visuals

Material dropdown currently renders a `Checkbox` for multi-select items.

We should formalize the multi-select visualization as a slot-friendly part:
- Ensure multi-select marker can be customized via `itemContent` without needing a full rewrite.
- Provide a cookbook recipe: “multi-select item row (checkbox + label) customization”.

---

### A2) Button (`RTextButton`) — bring it to the same slot quality as dropdown

Current state:
- `RButtonSlots` are simple widget fields (`child/icon/trailingIcon/spinner`).
- This is good for “replace content”, but weak for “decorate default structure”.

What we should improve (useful, not YAGNI):

#### A2.1 Add *decoratable* slots (context + default child)

We want to enable:
- wrap the whole surface (e.g. add gradient, shadow, clip),
- wrap the content area (e.g. add animation),
- override icon sizing without rebuilding content layout.

Decision (breaking OK, no legacy):

- Replace the current simple `RButtonSlots` with a SlotOverride-based structure aligned with dropdown.
- Do not introduce `RButtonSlotsV2` alongside legacy; migrate directly.

Target shape (illustrative):
- `RButtonSlots` becomes:
  - `surface: SlotOverride<RButtonSurfaceContext>?`
  - `content: SlotOverride<RButtonContentContext>?`
  - `leadingIcon: SlotOverride<RButtonIconContext>?`
  - `trailingIcon: SlotOverride<RButtonIconContext>?`
  - `spinner: SlotOverride<RButtonSpinnerContext>?`

Context requirements:
- must include `spec` + `state`
- must include `child` for Decorate defaults
- must include enough data to decorate safely without owning activation

#### A2.1.1 Button slot contexts (top-level shape)

Keep contexts small and renderer-friendly:

- `RButtonSurfaceContext`
  - `spec`, `state`
  - `child` (default surface child)
  - (optional) `resolvedTokens` or minimal fields like `borderRadius`
- `RButtonContentContext`
  - `spec`, `state`
  - `child` (default content widget)
- `RButtonIconContext`
  - `spec`, `state`
  - `child` (default icon widget)
- `RButtonSpinnerContext`
  - `spec`, `state`
  - `child` (default spinner widget)

#### A2.2 Button primitives (Material preset)

Material button renderer currently composes:
- `Material` + `AnimatedContainer` + `MaterialPressableOverlay`.

To make safe customization easier, define/standardize a minimal set of primitives:
- `MaterialButtonSurface` (background/border/radius/padding animation)
- reuse `MaterialPressableOverlay`

Goal:
- users can implement “custom button look” by composing primitives,
  without touching activation behavior.

---

### A3) Checkbox (`RCheckbox`, `RCheckboxListTile`) — minimal but practical slots

Current state:
- `RCheckbox` has no slots.
- `RCheckboxListTile` has `RCheckboxListTileSlots`, but they are plain widgets
  (no contexts, no Decorate/Replace policy).

What we should improve (useful, not YAGNI):

#### A3.1 Checkbox indicator slots (for real customization)

Real-world checkbox customization typically needs:
- custom mark (check / dash),
- custom box visuals (rounded/square),
- custom error visuals.

Proposed approach:
- Add `RCheckboxSlots` (SlotOverride-based) with at least:
  - `box` (surface of the checkbox indicator)
  - `mark` (check/dash)
  - `pressOverlay` (optional)
Each slot should support Replace/Decorate/Enhance (same `SlotOverride` model).

#### A3.1.1 Checkbox slot contexts (top-level shape)

- `RCheckboxBoxContext`
  - `spec`, `state`
  - `child` (default box)
- `RCheckboxMarkContext`
  - `spec`, `state`
  - `child` (default check/dash)
- `RCheckboxPressOverlayContext` (optional)
  - `spec`, `state`
  - `child` (default overlay wrapper)

#### A3.2 CheckboxListTile slots: evolve to SlotOverride for safety

Current `RCheckboxListTileSlots` are plain widgets. That encourages full replacement
without access to state/semantics context.

Proposed:
- Replace `RCheckboxListTileSlots` with a SlotOverride-based structure (no legacy layer kept):
  - `tile: SlotOverride<RCheckboxListTileTileContext>?` (wrap default ListTile)
  - `checkbox: SlotOverride<RCheckboxListTileCheckboxContext>?`
  - `title: SlotOverride<RCheckboxListTileTextContext>?`
  - `subtitle: SlotOverride<RCheckboxListTileTextContext>?`
  - `secondary: SlotOverride<RCheckboxListTileSecondaryContext>?`

This enables “add padding/background/animation” without replacing ListTile structure, while
still allowing Replace for advanced full takeovers.

#### A3.2.1 CheckboxListTile slot contexts (top-level shape)

- `RCheckboxListTileTileContext`
  - `spec`, `state`
  - `child` (default ListTile widget)
- `RCheckboxListTileCheckboxContext`
  - `spec`, `state`
  - `child` (default checkbox widget)
- `RCheckboxListTileTextContext`
  - `spec`, `state`
  - `child` (default text widget)
- `RCheckboxListTileSecondaryContext`
  - `spec`, `state`
  - `child` (default secondary widget)

---

