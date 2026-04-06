## Monorepo Architecture (feature-first + DDD + SOLID) (part 1) (part 2)

Back: [Index](/guide/implementation/other/ARCHITECTURE_part_01)

## Monorepo Architecture (feature-first + DDD + SOLID)

Goal: **not a monolith**, but a set of independent feature-based modules, while preserving **DDD** (Variants/Specs/Resolved/Contracts), **SOLID** (especially ISP/DIP) and requirements from `docs/MUST.md`.

### Related Documents

| Document | Contents | Key Sections |
|----------|----------|--------------|
| [`V1_DECISIONS.md`](./V1_DECISIONS.md) | Locked-in v1 decisions | [Contracts 0.1-0.7](./V1_DECISIONS.md#table-of-contents-quick-links), [API Stability](./V1_DECISIONS.md#api-stability-matrix-v10-locked-in), [D2a/D2b](./V1_DECISIONS.md#dual-api-d2a-now-path-to-d2b-later--locked-in) |
| [`MUST.md`](./MUST.md) | ROI priorities | Renderer contract (9/10), ISP (9/10), Parts/Slots (8/10) |
| [`RESEARCH.md`](./RESEARCH.md) | Competitor analysis | React Aria, Zag.js, Radix, Floating UI |
| [`SPEC_V1.md`](./SPEC_V1.md) | Normative specification for community components | MUST/SHOULD requirements, conformance, publishing rules |
| [`CONFORMANCE.md`](./CONFORMANCE.md) | How to claim Headless compatibility | Minimum checklist and required tests |
| [`implementation/I13_interaction_layers_and_owners.md`](./implementation/I13_interaction_layers_and_owners.md) | Implementation details (reference) | Interaction layers + owners (FocusNode/TextEditingController) |
| [`README.md`](/guide/implementation/README) | Roadmap | P0-P3 priorities, baseline tasks |

### Table of Contents (Quick Links)

**Structure:**
- [Folder tree](/guide/implementation/other/ARCHITECTURE_part_01_part_02#target-folder-tree)
- [Dependency rules (DDD + SOLID)](/guide/implementation/other/ARCHITECTURE_part_01_part_02#dependency-rules-ddd--solid)
- [Dual API policy](/guide/implementation/other/ARCHITECTURE_part_01_part_02#dual-api-policy-d2a-now-path-to-d2b-later)

**DDD/Clean Architecture:**
- [Domain Layer Invariants](/guide/implementation/other/ARCHITECTURE_part_01_part_02#where-state-must-not-live-ddd-discipline)
- [Bounded Contexts](/guide/implementation/other/ARCHITECTURE_part_01_part_02#bounded-contexts-ddd)
- [Ubiquitous Language](/guide/implementation/other/ARCHITECTURE_part_01_part_02#ubiquitous-language-glossary-of-terms)
- [CI Pipeline Integration](/guide/implementation/other/ARCHITECTURE_part_01_part_02#ci-pipeline-integration-github-actions)

**Quality:**
- [Renderer contracts](/guide/implementation/other/ARCHITECTURE_part_01_part_02#renderer-contracts-capability-discovery--api-stability-policy-v1)
- [LLM.txt policy](/guide/implementation/other/ARCHITECTURE_part_01_part_02#llmtxt-policy-for-each-component-package)
- [Interaction layers + Owners (locked in)](/guide/implementation/other/ARCHITECTURE_part_01_part_02#interaction-layers--owners-locked-in-how-to-do-it-right)
- [Performance](/guide/implementation/other/ARCHITECTURE_part_01_part_02#performance-important-for-headless)

---

### TL;DR (what the end result looks like)

- **Monorepo**: one repository -> many packages.
- **Component-based approach**: each component is a separate package, grouped under `packages/components/*`.
- **Shared building blocks**: `tokens`, `foundation`, `theme` are separate packages.
- **UX/discovery**: one facade package `headless` re-exports a "sensible default set", so the user doesn't have to assemble 10+ imports.
- **Truly headless**: visuals and structure live in **renderer contracts + renderer implementations**, not inside `R*`.
- **AI-friendly**: packages document invariants and examples in `LLM.txt` (or `docs/LLM.md`), so agents/generators don't break the rules.

Decisions locked in for v1 before implementation: `docs/V1_DECISIONS.md`.

---

### Spec-first: Headless = a standard for the ecosystem (and we only do it this way)

The project goal is not just "another component library", but a **specification (standard) + core contracts**, by which:

- any author can create a publishable component package and claim compatibility,
- other people can use that package without fear of hidden dependencies and "magical" behavior.

**The only acceptable path to compatibility:**

- **Core contracts and invariants** are locked in `docs/V1_DECISIONS.md` (and implemented in core packages).
- **Requirements for external packages** are formulated normatively in `docs/SPEC_V1.md` (MUST/SHOULD/MAY).
- **The "passes conformance" process** and compatibility checklist are described in `docs/CONFORMANCE.md`.

If a package **does not** follow `docs/SPEC_V1.md` or cannot pass conformance, it **is not considered Headless-compatible** (even if it "looks similar" in API).

#### Definition of Done: Headless-compatible package (v1)

A package may only be called Headless-compatible if all of the following are satisfied:

- **Follows `docs/SPEC_V1.md`**: layer structure, dependencies, headless separation, ownership, etc.
- **Passes conformance**: minimum checks/tests from `docs/CONFORMANCE.md` are implemented and green.
- **No component -> component deps**: the package does not import other `packages/components/*`.
- **Renderer capability is required**: no hidden baseline UI; missing capability produces clear diagnostics.
- **Controlled/uncontrolled are correct**: external `controller/value` is not overwritten; ownership dispose is respected.
- **Has `LLM.txt`**: Purpose/Non-goals/Invariants/Correct usage/Anti-patterns.

**Core contracts v1** (see `docs/V1_DECISIONS.md` -> "Minimal public contract surface v1"):
- `0.1` - Renderer contracts (theme + slots)
- `0.2` - Overlay (Host/Controller/Handle + FocusPolicy)
- `0.3` - Listbox (Controller/Registry + ListboxNavigation)
- `0.4` - StateResolution (Policy/Map)
- `0.5` - Test helpers
- `0.6` - Interactions (Controller -> WidgetStateSet)
- `0.7` - Effects executor (lifecycle + order)

---

### How we lock in research (to avoid doing "like they do")

- **`docs/RESEARCH.md`**: raw research, comparisons, ideas. We also mark: **Adopt / Reject / Open**.
- **`docs/V1_DECISIONS.md`**: only **accepted v1 decisions** (clear contracts and invariants).
- **`docs/ARCHITECTURE.md`**: only what has already become an **architectural rule** (package boundaries, dependencies, invariants).
- **`docs/SPEC_V1.md`**: **normative requirements** for third-party packages, so they are considered Headless-compatible (conformance).
- **`docs/CONFORMANCE.md`**: **how to claim compatibility** and what minimum tests/checks are required.

Rule: if an idea from research "seems cool" but breaks POLA/DDD/DAG or adds magic, we **explicitly write that it's bad, and we don't do it**.

---

### Target Folder Tree

```text
headless/
├─ packages/
│  ├─ headless_tokens/                  # Raw + semantic tokens (extension types)
│  │  └─ lib/src/{raw,semantic}/...
│  │
│  ├─ anchored_overlay_engine/         # Overlay engine (lifecycle/policies/positioning)
│  │  └─ lib/src/
│  │     ├─ host/                       # AnchoredOverlayEngineHost + scope (layer ownership)
│  │     ├─ controller/                 # OverlayController + OverlayHandle (show/close/update)
│  │     ├─ positioning/                # Anchor/placement/flip/shift/collision
│  │     ├─ policies/                   # Dismiss/Focus/Barrier/Stack policies
│  │     └─ insertion/                  # OverlayPortal backend
│  │
│  ├─ headless_foundation/              # Shared UI behavior engines (focus/fsm/state/listbox)
│  │  └─ lib/src/
│  │     ├─ focus/
│  │     ├─ interactions/                  # Unified press/hover/focus policies (single place for input edge-cases)
│  │     ├─ fsm/
│  │     ├─ listbox/                       # ItemRegistry + navigation/typeahead (menu-like patterns)
│  │     └─ state_resolution/
│  │
│  ├─ headless_contracts/               # Renderer contracts + slots + overrides
│  │  └─ lib/src/
│  │     ├─ renderers/                    # Renderer contracts (ButtonRenderer/...)
│  │     └─ slots/                        # SlotOverride/Replace/Decorate/Enhance
│  │
│  ├─ headless_theme/                   # Theme runtime + capability overrides + bootstrap
│  │  └─ lib/src/
│  │     ├─ theme/                        # Capability discovery + overrides scopes
│  │     ├─ motion/                       # Motion theming helpers
│  │     └─ widget_states/                # State normalization helpers
│  │
│  ├─ headless_material/                # Preset renderers (Material 3), not in core
│  │  └─ lib/src/...
│  ├─ headless_cupertino/               # Preset renderers (Cupertino), not in core
│  │  └─ lib/src/...
│  │
│  ├─ headless_test/                    # Optional test helpers (a11y/overlay/focus/keyboard), no UI
│  │  └─ lib/src/...
│  │
│  ├─ components/                         # Grouping of component packages (not a "components package")
│  │  ├─ headless_button/               # Component: Button
│  │  │  └─ lib/src/
│  │  │     ├─ domain/                    # variants/specs/resolved only for button
│  │  │     ├─ presentation/              # RTextButton + parts/slots API (if needed)
│  │  │     └─ infra/                     # adapters/bridges (no baseline visuals by default)
│  │  │
│  │  ├─ headless_dropdown_button/      # Component: DropdownButton (listbox + overlay)
│  │  └─ ...                              # Other components as they grow
│  │
│  └─ headless/                         # Facade package (single public API)
│     └─ lib/headless.dart              # re-export of components and shared modules
│
├─ tools/
│  └─ headless_cli/                     # Optional tooling: W3C import + skeleton generation (no UI logic)
│
├─ apps/
│  └─ example/                            # Example application (demo brands/cases)
│
└─ docs/
   ├─ ARCHITECTURE.md
   ├─ V1_DECISIONS.md
   ├─ SPEC_V1.md
   ├─ CONFORMANCE.md
   ├─ MUST.md
   ├─ RESEARCH.md
   ├─ WHY_HEADLESS.md
   ├─ CHANGELOG.md
   └─ competitors/
```

---

### Dependency Rules (DDD + SOLID)

#### Within each component package (`packages/components/headless_*`)

```text
presentation  -> domain
infra         -> domain
presentation  -> (headless_contracts, headless_theme, headless_foundation, headless_tokens)
infra         -> (headless_contracts, headless_theme, headless_tokens)
domain        -> (nothing, or only dart:* / meta)
```

Overlay API lives in `anchored_overlay_engine`; during the transition period, import
via `headless_foundation/overlay.dart` (compat) is allowed.

- **No cycles (mandatory rule)**:
  - The package dependency graph must be a **DAG** (no circular dependencies).

- **No "component -> component" (recommended rule)**:
  - component Dialog does not depend on Button, `headless_dropdown_button` does not depend on the dialog component, etc.
  - If it seems like "it's needed", it means the shared mechanism should live in `headless_foundation` or `headless_theme`, not in a specific component.

---

### Public API discipline (critical for scaling)

Goal: users and other packages should depend **only on stable public API**, not on internal details.

- **MUST**: cannot import/export other packages' internal files: `package:<pkg>/src/...`.
- **MUST**: cross-package imports must go **only through the entrypoint**: `package:<pkg>/<pkg>.dart`.
- **MUST**: entrypoint (`lib/<pkg>.dart`) **does not export `src/` directly** - instead it exports public `lib/*.dart` facades.

This is guaranteed by guardrails checks (see `tools/headless_cli/bin/guardrails.dart`).

---

### Dependency Table (what each package is allowed to import)

Goal: a simple rule for review - **we don't allow implicit links** between components.

| Package | Allowed dependencies | Forbidden |
|---------|---------------------|-----------|
| `headless_tokens` | `dart:*`, `dart:ui` (Color, etc.) | `flutter:*`, everything else |
| `headless_foundation` | `headless_tokens`, `dart:*`, `flutter:foundation`, `flutter:widgets`, `flutter:rendering` | `headless_contracts`, `headless_theme`, any components |
| `headless_contracts` | `headless_foundation`, `dart:*`, `flutter:foundation`, `flutter:widgets` | any components |
| `headless_theme` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `dart:*`, `flutter:foundation`, `flutter:widgets` | any components |
| `headless_material` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | any components, `headless` (facade) |
| `headless_cupertino` | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | any components, `headless` (facade) |
| `headless_test` | `flutter_test`, `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | any components, `headless` (facade) |
| `packages/components/headless_*` (any component) | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, `dart:*`, `flutter:*` | other components (and any cycles) |
| `headless` (facade) | `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme`, components | reverse dependencies (nobody should depend on the facade) |
| `apps/example` | `headless` (preferred) and/or any packages | - |

#### Visual DAG Dependency Diagram

```text
                           ┌─────────────────┐
                           │   apps/example  │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │   headless    │  (facade)
                           │    (re-export)  │
                           └────────┬────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
┌───────▼───────┐         ┌─────────▼─────────┐       ┌─────────▼─────────┐
│  headless_  │         │  headless_      │       │  headless_      │
│  button       │         │  dropdown_button  │       │  dialog           │
└───────┬───────┘         └─────────┬─────────┘       └─────────┬─────────┘
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    │
             ┌──────────────────────┼──────────────────────┐
             │                      │                      │
    ┌────────▼────────┐    ┌────────▼────────┐    ┌────────▼────────┐
    │ headless_test │    │ headless_     │    │ headless_     │
    │  (dev only)     │    │ presets        │    │ theme           │
    └────────┬────────┘    └────────┬────────┘    └────────┬────────┘
             │                      │                      │
             │                      │                      │
             └──────────────────────┼──────────────────────┘
                                    │
                           ┌────────▼────────┐
                           │  headless_    │
                           │  foundation     │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │  headless_    │
                           │  tokens         │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │    dart:core    │
                           │    dart:ui      │
                           └─────────────────┘

Arrows point DOWN = "depends on". Cycles are forbidden (DAG).
```
