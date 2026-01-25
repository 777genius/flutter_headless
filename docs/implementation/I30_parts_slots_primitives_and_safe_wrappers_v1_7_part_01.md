## I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7) (part 1)

Back: [Index](./I30_parts_slots_primitives_and_safe_wrappers_v1_7.md)

## I30 — Parts/Slots + Primitives + Safe Wrappers (v1.7)

### Why this iteration exists

Right now, “custom renderer” is too easy to get wrong:

- You can accidentally create a second activation path (double invoke).
- You can break overlay close contract (`completeClose()`).
- You can regress semantics/a11y silently.

The goal is not to ban custom renderers. The goal is to make the **default customization path safe** and to make “full takeover” an explicitly advanced path.

This iteration focuses on **three components first**:

- Button (`RTextButton`)
- Dropdown (`RDropdownButton<T>`)
- Checkbox (`RCheckbox`, plus `RCheckboxListTile` where it matters)

---

### Decisions (locked for v1.7)

1) **Breaking changes are OK** — but we must not keep legacy compatibility layers.
2) **Material primitives will be a dedicated public layer** (not “export internal `src/primitives` as-is”).
3) **CheckboxListTile will be fully slot-customizable** (quality-first).
4) **Safe wrappers live in core contracts** with an optional DX facade layer:
   - core scaffolds in `headless_contracts`
   - optional convenience wrappers in `headless_theme`
5) **Execution plan: one big PR** for the whole monorepo change.
   - Reason: avoids a “temporary legacy window” and keeps the ecosystem consistent.

---

### Architecture (top-level)

This iteration intentionally splits responsibilities:

- `headless_contracts`
  - owns renderer contracts + slots + typed slot contexts,
  - owns “safe scaffolds” (Track B core),
  - must not depend on Material/Cupertino.
- Presets (`headless_material`, `headless_cupertino`)
  - implement contracts,
  - dogfood slots and safe scaffolds,
  - provide style-specific primitives (Material via a dedicated public layer).
- `headless_theme`
  - remains theme/capability wiring + DX sugar,
  - may expose thin facades for safe scaffolds (optional),
  - must not duplicate invariants logic.

---

### High-level approach (two tracks)

#### Track A — Strong customization via parts/slots + primitives

Make it possible to customize visuals without re-implementing full renderers:

- **Parts/slots**: stable extension points that keep structure/semantics/activation policy.
- **Primitives**: small reusable widgets with predictable behavior (or intentionally no behavior).

Principle: **most real-world UI customizations should be possible using parts/slots + primitives**.

#### Track B — Safe wrappers for “full takeover”

When someone truly needs to replace a renderer, give them a safe scaffold:

- close contract handled automatically (for overlays),
- default semantics guardrails,
- guidance and debug-only invariants checks.

Principle: **full takeover is allowed, but it comes with rails**.

---

### Definitions (consistent terminology)

- **Primitives**: small widgets intended to be used by renderers and slot overrides
  (e.g. menu surface, menu item, press overlay). They should be stable and boring.
- **Parts**: named sub-areas of a component’s visual tree (trigger surface, item row, marker).
- **Slots**: public extension points that let the user Replace/Decorate/Enhance parts while
  keeping behavior/a11y consistent.

Rule of thumb:
- If the user wants “wrap default UI” → use `Decorate`.
- If the user wants “change a few knobs” → use `Enhance` or tokens/overrides.
- If the user wants “completely different structure” → use `Replace` (advanced).

---

### Design constraints (non-negotiable)

These come from `docs/implementation/I13_interaction_layers_and_owners.md`:

1) **Single activation source**: component owns activation and Semantics onTap.
2) **Renderer does not add its own activation path** (no `InkWell(onTap: ...)` on root).
3) **Overlay close contract**: if renderer animates exit, it must call `completeClose()`
   (prefer `CloseContractRunner`).
4) **Tokens policy**: when strict tokens are enabled, renderers must not “guess” tokens.

---

## Deliverables by package (top-level)

### `headless_contracts`

- SlotOverride-based slots + typed contexts for:
  - Button (`RButtonSlots` + contexts)
  - Checkbox (`RCheckboxSlots` + contexts)
  - CheckboxListTile (`RCheckboxListTileSlots` + contexts)
- `SafeDropdownRenderer` scaffold (MVP) + minimal docs/dartdoc.

### `headless_material`

- Public primitives layer:
  - `lib/primitives.dart`
  - `lib/primitives/*` (see A1.1.1)
- Preset renderers migrated to import primitives from `package:headless_material/primitives.dart`.
- Dogfood: Material dropdown/menu/button/checkbox use the public primitives.

### Components packages (button / dropdown / checkbox)

- Components wire the new SlotOverride-based slots through render requests.
- No legacy parallel slot APIs remain after the PR.

---

## Breaking changes (explicit)

This iteration is intentionally breaking. The “one big PR” must include:

- Button:
  - `RButtonSlots` changes from “plain widget fields” to SlotOverride-based slots.
- Checkbox:
  - New `RCheckboxSlots` added to support indicator parts.
- CheckboxListTile:
  - `RCheckboxListTileSlots` changes from “plain widget fields” to SlotOverride-based slots.

Non-breaking (should remain stable):
- Dropdown slot model stays SlotOverride-based (already aligned).

---

