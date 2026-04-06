## Monorepo Architecture (feature-first + DDD + SOLID) (part 1) (part 3)

Back: [Index](/guide/implementation/other/ARCHITECTURE_part_01)

- **Domain**:
  - `variants/` (sealed classes)
  - `specs/` (value objects)
  - `resolved/` (resolved output)
  - No "UI structure" or "rendering".
- **Presentation**:
  - `R*` manages **behavior/states/a11y** and assembles the spec.
  - Visuals are delegated to the renderer (contracts in `headless_contracts`, discovery in `headless_theme`).
- **Infra**:
  - Adapters and component infrastructure (e.g., glue code for theme contracts), but renderer implementations live in preset packages (`headless_material`, `headless_cupertino`) or in the application.

#### Shared Packages

- `headless_contracts`:
  - Renderer/token resolver contracts + slots + per-instance overrides.
  - Shared language between components and preset implementations.
- `headless_theme`:
  - Capability discovery + overrides scopes + HeadlessApp.
  - Motion/widget state helpers for presets and components.
- `anchored_overlay_engine`:
  - Solve the hard problem once (overlay lifecycle/policies/positioning/insertion) -> reuse across all features.
  - Overlay positioning (locked in):
    - `anchored_overlay_engine/src/positioning/anchored_overlay_layout.dart` - base collision pipeline v1: flip + horizontal shift + maxHeight accounting for safe area/keyboard.
  - Overlay reposition policy (locked in):
    - reposition is triggered by scroll/metrics (keyboard/resize) and coalesced to <= 1 time per frame (`OverlayController.requestReposition()`).
  - Overlay update triggers v1.1 (locked in):
    - optional ticker in `AnchoredOverlayEngineHost(enableAutoRepositionTicker: true)` - for rare cases when the anchor moves without scroll/metrics.
    - SLA conformance tests must cover flip/shift/maxHeight updates on scroll/metrics/ticker.
  - Overlay lifecycle v1: the `opening/open/closing/closed` phase is exposed as `ValueListenable` (so the renderer can do enter/exit without workarounds; see `docs/V1_DECISIONS.md`).
  - Close contract v1: `close()` transitions to `closing`, and close completion happens through `OverlayHandle.completeClose()` (there is a fail-safe timeout to prevent getting stuck in `closing`; see `docs/V1_DECISIONS.md`).
  - Overlay API is locked in as `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle` (without Navigator).
  - Compat: `headless_foundation/overlay.dart` re-exports the API for the transition period.
- `headless_foundation`:
  - Solve the hard problem once (focus/fsm/listbox/state resolution) -> reuse across all features.
  - Interaction layers (locked in):
    - `HeadlessPressableController/Region` - button-like behavior (pressed/hover/focus + anti-repeat)
    - `HeadlessFocusHoverController/HoverRegion` - hover+focus for input-like (without activation)
  - Ownership helpers (locked in):
    - `HeadlessFocusNodeOwner` - ownership/replacement/safe dispose of `FocusNode`
    - `HeadlessTextEditingControllerOwner` - ownership/replacement/safe dispose of `TextEditingController`
  - Menu-like patterns are built through `listbox/*` mechanisms, not through a component package.
- `headless_tokens`:
  - Raw + semantic tokens (laying the groundwork for multi-brand and stable API).
  - **v1 policy:** semantic tokens = **W3C-first + hybrid**:
    - small whitelist of **global semantic primitives**
    - everything specific goes through `components.*` semantic tokens (we don't bloat the global layer)
    - brand overrides through W3C `$extends` / group inheritance (see `docs/V1_DECISIONS.md`)

#### Foundation <-> Theme Contract (guarantees, not dependencies)

Foundation provides mechanisms; Theme must use them correctly:

| Foundation Mechanism | Theme Contract |
|---------------------|----------------|
| `OverlayHandle.phase` | Renderer listens to phase, renders enter/exit animations |
| `OverlayHandle.completeClose()` | Renderer calls after exit animation |
| `StateResolutionPolicy` | Theme uses precedence for token resolution |
| `ListboxController.highlightedId` | Renderer visually marks the highlighted item |
| `InteractionController.states` | Renderer applies states to token lookup |

**This is NOT a dependency** (foundation does not import theme), but a **contract guarantee**. Theme relies on the stability of these mechanisms.

**Foundation types exposed to Theme/Renderers:**

| Type | Package | Used in | Stability |
|------|---------|---------|-----------|
| `OverlayHandle` | anchored_overlay_engine | Renderer receives via OverlayScope | `@stable` |
| `OverlayPhase` | anchored_overlay_engine | Renderer listens to phase changes | `@stable` |
| `WidgetStateSet` | headless_foundation | Renderer receives for token resolution | `@stable` |
| `ListboxItemId` | headless_foundation | Renderer highlights items by ID | `@stable` |
| `StateResolutionPolicy` | headless_foundation | Theme uses for token precedence | `@stable` |
| `TokenResolver<T>` | headless_contracts | Capability exposes for token resolution | `@stable` |
| `CloseReason` | anchored_overlay_engine | Renderer may inspect close reason | `@stable` |

Detailed contracts: `docs/V1_DECISIONS.md` -> sections 0.1-0.7.

---

### Dual API policy (D2a now, path to D2b later)

In v1 we consider the "advanced / power user" level part of **foundation**, not part of each component:

- **D2a (v1)**: public `anchored_overlay_engine` (overlay) + `headless_foundation` (listbox/focus/fsm) + regular `R*` widgets.
- **D2b (later, if needed)**: per-component engines are allowed only if they:
  - are a **thin wrapper** over the same events/state that `R*` uses,
  - do not duplicate overlay/listbox mechanisms (overlay stays in `anchored_overlay_engine`, listbox/focus/fsm stays in `headless_foundation`),
  - are added **additively** (without changing default behavior and without breaking).

Goal: provide maximum customization without turning the system into a set of inconsistent "two different APIs".

---

### How this directly covers `docs/MUST.md`

- **Renderer contract (9/10)**: contracts in `headless_contracts/src/renderers/*`, implementations in preset packages (`headless_material`, `headless_cupertino`) or in the application/brands (not in `components/*`).
- **Parts/Slots API (8/10)**: lives in `components/*/presentation` (component anatomy), but without leaking into tokens/foundation.
- **Theme runtime (9/10)**: `headless_theme/src/theme/*` + scopes/overrides.
- **State resolution (8/10)**: `headless_foundation/src/state_resolution/*`.
- **FSM (8/10)**: `headless_foundation/src/fsm/*` - **optional pattern** on top of E1, not part of core contracts. Used in complex components (Select, Dialog), but not required (see V1_DECISIONS.md -> "FSM as optional pattern").
- **Overlay infra (7/10)**: `anchored_overlay_engine/src/*` and dialog components.
- **Semantic tokens (7/10)**: `headless_tokens/src/semantic/*`.
- **API stability (8/10)**: achieved through capability discovery/optional wiring in `headless_theme`.
- **Behavior + a11y tests (7/10)**: tests live alongside features and foundation (no golden tests by default).

---

### Renderer contracts: capability discovery + API stability policy (v1)

Goal: so that we can **add capabilities additively** (minor), without breaking users and without bloating a "monolithic theme".

#### Principles

- **ISP**: instead of "one big theme" we make small capabilities (`ButtonRenderer`, `DialogRenderer`, ...).
- **Discovery**: capability presence is determined through `RenderlessTheme`/composition layer (not through `if (theme is FooTheme)`).
- **Components don't know implementations**: `R*` imports only contracts (from `headless_contracts`), not default renderers.

#### Evolution Rules (to avoid migrations)

- **Additive-only in minor**:
  - new capabilities - only as **optional** fields/composition with defaults,
  - new parts/slots - only additive (existing ones don't disappear),
  - new tokens - only additive and following semantic tokens v1 rules.
- **Breaking = only major**:
  - renaming/removing renderer API,
  - changing default behavior,
  - changing capability optionality.
- **Missing renderer = explicit error**:
  - if a user plugged in a component but did not provide the corresponding renderer capability, this should produce clear diagnostics (assert/throw with instructions on how to connect the `headless` facade or their own theme composition).

References: `docs/V1_DECISIONS.md` (renderer/parts/overlay).

---

### Interaction layers + Owners (locked in, how to do it right)

Goal: so that as components grow, interaction "wiring" and object lifecycle don't get copied and drift.

#### Semantics policy (must)

- **Root Semantics belong to the component (`R*`)**.
- Renderer may add local semantics inside, but **must not duplicate root ones** (otherwise a11y becomes unpredictable).

#### Interaction layers (must)

- **Pressable surfaces** (buttons, dropdown trigger):
  - Use `HeadlessPressableController` + `HeadlessPressableRegion`.
  - Standardizes: pressed/hover/focus/disabled + keyboard activation Space/Enter (anti-repeat).
- **Hover+Focus surfaces** (textfield-like):
  - Use `HeadlessFocusHoverController` + `HeadlessHoverRegion`.
  - Hover provides a region, focus comes from `FocusNode` (focus source is the input).

#### Owners (must)

Ownership rule: if an object is passed from outside, we **do not dispose** it.

- `HeadlessFocusNodeOwner`:
  - creates an internal `FocusNode` if none is provided externally
  - correctly switches when `widget.focusNode` changes
  - disposes only the internal node (+ safe `unfocus()` before dispose)
- `HeadlessTextEditingControllerOwner`:
  - creates an internal `TextEditingController` if none is provided externally
  - correctly switches when `widget.controller` changes
  - disposes only the internal controller

Details and examples: `docs/implementation/I13_interaction_layers_and_owners.md`.

---

### Tokens pipeline v1: W3C -> `headless_tokens` (no runtime parsing)

Goal: one source of truth for multi-brand, without "runtime magic".

- **Source of truth**: W3C Design Tokens JSON (with `$extends`, `$type`, aliases).
- **Import**: `tools/headless_cli` (optional tooling) reads W3C JSON and generates Dart token code in `headless_tokens`.
- **Runtime**: no JSON parsers and `$extends` resolution at runtime; the application uses typed tokens.
- **Color spaces**: P3/OKLCH can be accepted as input, but in v1 we convert to **sRGB at import time** (see `docs/V1_DECISIONS.md`).

---

### Governance v1: how we make architectural decisions

Goal: to avoid architecture "drift" and hidden incompatibilities as packages grow.

- **Single source of v1 decisions**: any changes affecting contracts of `headless_tokens` / `headless_foundation` / `headless_contracts` must be accompanied by an update to `docs/V1_DECISIONS.md` (or an explicit note "why not needed").
- **Spec-first invariant**: any changes affecting compatibility of third-party component packages must be accompanied by an update to `docs/SPEC_V1.md` and `docs/CONFORMANCE.md`.
- **No "silent" behavior changes**: any change to defaults/invariants is either a minor with explicit changelog description, or a major.
- **PR discipline**: the PR checklist from this document is mandatory; if the checklist "doesn't pass" - the decision is not ready.

### "Not a monolith" policy (module boundaries)

- Any new component starts as a **new component package** in `packages/components/`.
- Shared code is "extracted" upward only if it:
  - is used **in at least 2-3 features**, and
  - can be formulated as a **general mechanism** (overlay/focus/fsm/state), not as "a piece of a specific component".

---

### PR Review Checklist (quick architecture verification)

- **Spec-first**:
  - If public contracts/invariants or "what compatibility means" were changed - `docs/V1_DECISIONS.md` and/or `docs/SPEC_V1.md`, and if necessary `docs/CONFORMANCE.md`, are updated.

- **Package boundaries**:
  - Changes affect only "their own" feature/package and shared packages as appropriate.
  - No imports of other components from `packages/components/*`.

- **Dependencies**:
  - No circular dependencies added (DAG).
  - `domain/` does not import Flutter UI/renderer implementations (only specifications/contracts).

- **SOLID**:
  - New functionality is added through capability/contract, not through extending a "big" interface unnecessarily (ISP).
  - `R*` depends on abstractions (capabilities/renderers), not on a specific theme/renderer (DIP).

- **POLA**:
  - Default component behavior is predictable (disabled/loading/focus).
  - No "magical" side effects (e.g., unexpected focus changes/closings) without an explicit option/contract.

- **AI metadata (LLM.txt)**:
  - If the package's public API/invariants changed - `LLM.txt` (or `docs/LLM.md`) in that package is updated.

- **A11y (manual layer)**:
  - For new/changed overlay/complex components, minimum manual verification performed: **keyboard-only** + **screen reader** (VoiceOver/NVDA/JAWS).

---

### AI/MCP metadata policy (LLM.txt) - v1

Goal: so that AI/agents and codegen tools use Headless **correctly** and don't violate invariants.

**Rule:**
- For each publishable package, add a **`LLM.txt`** file at the package root (next to `pubspec.yaml`).
- If markdown/links are needed - `docs/LLM.md` is acceptable, but the "short summary" must still be in `LLM.txt`.

**Minimum `LLM.txt` contents:**
- **Purpose**: what the package does (1-3 sentences).
- **Non-goals**: what the package *does not* do (so the agent doesn't add "magic").
- **Invariants**: 5-10 items (overlay closing phase, focus restore, state resolution, no component->component deps, etc.).
- **Correct usage**: 2-3 short examples.
