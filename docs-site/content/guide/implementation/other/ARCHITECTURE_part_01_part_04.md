## Monorepo Architecture (feature-first + DDD + SOLID) (part 1) (part 4)

Back: [Index](/guide/implementation/other/ARCHITECTURE_part_01)

- **Anti-patterns**: 3-5 "don'ts".

**When to update:**
- Any change to public API, invariants, or default behavior of a package -> **update `LLM.txt` in the same PR**.

### Typical Cases (where to put code so as not to break boundaries)

Below are situations that arise almost always. Goal: prevent **component -> component** links, but without losing convenience and reuse.

#### Case 1: "Dialog wants Button" (don't do `dialog -> button`)

- **Anti-pattern**: dialog component imports `headless_button` to render actions.
- **Correct approach**:
  - `Dialog` declares **parts/slots** (e.g. `actions` as `Widget`/builder) in its `presentation`.
  - The specific application/facade decides what to pass into `actions` (whether `RTextButton` or any other widget).
  - If uniform layout/spacing/behavior is needed - that's **semantic tokens** (`tokens/semantic`) or the dialog **renderer**, not a dependency on button.

#### Case 2: "DropdownButton wants Dialog/Overlay" (don't do `dropdown -> dialog`)

 - **Anti-pattern**: `DropdownButton` uses `RDialog` as a "ready-made popup".
- **Correct approach**:
  - Everything related to portal/positioning/barriers/scroll/close-on-outside-click is `anchored_overlay_engine`.
  - `DropdownButton` uses the overlay mechanism directly.
  - `Dialog` also uses the overlay mechanism directly. Both components become independent.

#### Case 3: "Multiple components want the same hover/pressed/focus logic"

- **Anti-pattern**: copying handlers into each `R*`.
- **Correct approach**:
  - Shared interaction policies go in `headless_foundation/interactions` and/or `state_resolution`.
  - Components plug into the shared mechanism and feed their input signals (gesture/focus), rather than implementing everything from scratch.

#### Case 4: "Need unified state priority rules" (pressed vs disabled vs focused)

- **Anti-pattern**: "whatever happened to work" via `if` in each component/theme.
- **Correct approach**:
  - Priority and combination rules are centralized in `headless_foundation/state_resolution`.
  - Theme/renderer receives already normalized states and behaves predictably (POLA).

#### Case 5: "Want a shared visual pattern: buttons in a dialog look like this"

- **Anti-pattern**: hard-coding structure and widgets inside `Dialog`.
- **Correct approach (headless)**:
  - Either it's the dialog **renderer** (structure/layout/effects) + semantic tokens.
  - Or it's solved **in the application** via composition: passing the needed actions.

#### Case 6: "User doesn't want 10 imports"

- **Correct approach**:
  - `packages/headless` (facade) re-exports popular components and base contracts.
  - Meanwhile, components remain separate packages (can be added individually).

#### Case 7: "Seems like a shared UI component is needed (e.g., Divider/Label/Spinner)"

- **Check before extracting**:
  - Is this really a "component", or is it part of a specific feature's renderer?
- **Rule**:
  - If it's a **pure primitive/mechanism** -> `headless_foundation` or `headless_tokens`.
  - If it's a **piece of specific structure** -> it stays inside the feature in renderer/parts.

---

### Threshold for extraction to `headless_foundation` (the proper 2-3 features rule)

`headless_foundation` is an **infrastructure layer** that should be maximally stable. A common mistake is putting "shared UI pieces" or "convenient components" there. We don't do that.

#### What "foundation" is (and what it is not)

- **Foundation = behavior mechanisms** (cross-cutting):
  - overlay/portal/positioning (anchored_overlay_engine), dismiss, scroll strategies
  - focus management, focus trap, keyboard navigation policy
  - interactions (pressed/hovered/focused) as a policy, not markup
  - state resolution (priorities/normalization of states)
  - FSM primitives for complex interactive patterns
  - a11y utilities at the "behavior/semantics" level, not visuals

- **NOT foundation**:
  - ready-made visual widgets/structures (those are renderer/parts inside a specific feature)
  - "resolved style" models of a specific component (any `Resolved*` types tied to one component)
  - "piece of dialog" or "piece of select" needed by only one component
  - theme implementations (branded themes/renderers)

#### The 2-3 features rule (threshold)

We use 3 decision levels:

- **Level A - stays in the component (default)**:
  - used in **1 component**, or
  - it's a "structural piece" of renderer/parts, or
  - the mechanism depends on domain types of a specific component.

- **Level B - candidate for foundation (2 features)**:
  - the same logic/invariants are used **in at least 2 components**, and
  - it is specifically a **behavior mechanism**, and
  - a stable contract can be described without tying to a component's domain.
  - Action: extract to foundation **only if** it's already clear what extension "knobs" are needed (POLA).

- **Level C - foundation is mandatory (3+ features)**:
  - the mechanism is needed **in 3+ components** (or it's an obvious platform: overlay/anchoring, focus, state_resolution), and
  - code duplication leads to behavioral divergence.
  - Action: extract to foundation and lock in the API/contract.

#### Checklist before extraction (to avoid "polluting foundation")

Before extracting, answer "yes" to all:

- **Mechanism, not widget**: this is behavior/policy, not markup.
- **No domain binding**: does not depend on `ButtonSpec/DialogSpec/...`.
- **Clear contract**: inputs/outputs and invariants can be formulated.
- **Testability**: behavioral tests can be written without golden tests.
- **POLA**: defaults are predictable, no hidden side effects.

If even one item is "no" - keep it inside the component and revisit later.

---

### Versioning Policy (SemVer) for monorepo packages

Goal: avoid a "compatibility matrix" of dozens of packages. For design systems this is critical, because users care more about **predictability** than micro-optimized releases.

#### Recommendation: lockstep versioning for all public packages

We maintain **one shared version `X.Y.Z`** for:

- `headless_tokens`
- `headless_foundation`
- `headless_contracts`
- `headless_theme`
- `headless` (facade)
- all `packages/components/headless_*`

Why this is correct:

- The user sees **one system version**, not "button@2.x + dialog@5.x + theme@1.x".
- Reduces the risk of incompatible combinations.
- Easier to maintain documentation, examples, and migrations.

#### SemVer Rules (what counts as patch/minor/major)

- **PATCH (`X.Y.Z+1`)**:
  - bug fixes, documentation fixes, internal refactorings without public API changes
  - performance fixes without changing default behavior

- **MINOR (`X.(Y+1).0`)**:
  - adding new capabilities **additively** (new components, new capabilities, new tokens)
  - new options/fields with default values that preserve old behavior (POLA)
  - new renderer parts/slots without changing current defaults

- **MAJOR (`(X+1).0.0`)**:
  - any breaking change to public API (signatures, removals, renames)
  - changing default behavior that may "break expectations"
  - removing previously deprecated API

#### Deprecation Policy (to make migrations smooth)

- Any planned removal is first marked as deprecated.
- **At least 1 MINOR release** the API lives in deprecated state.
- Removal happens only in the **next MAJOR**.

Principle: if a user updated to a new minor, they should get a warning and time to migrate, not a sudden breakage.

#### Dependency Compatibility (invariant)

- Components and facade depend on core packages within **one MAJOR**.
- Any release `X.Y.Z` guarantees that all packages with version `X.Y.Z` are compatible with each other.

#### Release Discipline (minimal, but strict)

- One release = one set of changes across all packages under one version.
- For each release:
  - short changelog (what was added/fixed/broken)
  - if there are breaking changes - migration notes

This supports POLA and reduces the cost of upgrades for library users.

---

### State Management - what we recommend in Headless

Key principle: **Headless does not impose a state manager** (Riverpod/BLoC/MobX/Redux etc.) on the user.
Our job as a library is to provide **universal contracts**, so any state manager can control components from above.

#### 1) Controlled / Uncontrolled model (like Flutter `TextField`)

- **Controlled**: state comes from outside via `value/state` + `onChanged`.
- **Uncontrolled**: the component stores state internally (if `controller/value` is not provided).
- **POLA rule**: if controller/value is provided, the component does not "overwrite" state on its own.

Why: this allows "plugging in" a component to any state manager without forks.

#### 2) Controller approach + `ValueListenable` as the minimum common denominator

For interactive components (input/select/tabs etc.) the best base contract is:

- a controller object (similar in concept to `TextEditingController`)
- externally we expose observation via `ValueListenable<T>` / `Listenable`

Why this is "Google-level":

- 0 external dependencies
- compatible with all approaches (can wrap in stream, mobx, riverpod, bloc)
- predictable lifecycle: controller is created/passed/disposed by the rules

#### 3) Immutable State Object + events for complex components

For complex things (`Select/Combobox/Menu`):

- state is described as **immutable state** (`copyWith`/pattern matching)
- updates happen through **explicit events** (open/close/select/highlight/blur...)
- internally FSM is allowed (see `headless_foundation/fsm`) - but externally we still expose "current state" and callbacks

This reduces "magical" side effects and makes behavior testable.

#### 3.1) Behavior standard for complex components (E1)

For `Dialog`, `Select/Combobox` and menu-like patterns we use a unified standard:

- **Events**: `sealed` events
- **State**: immutable state object
- **Reducer core**: `reduce(state, event) -> (nextState, effects)` (pure)
- **Effects**: separate side-effect layer (overlay/focus/announce/reposition), so the core remains pure

FSM is allowed **on top of** this standard (as modes in state or as strict transition rules inside the reducer), but not instead of it.

This also naturally aligns with UDF (Unidirectional Data Flow): **state down**, **events up** - which matches current Flutter app architecture recommendations and reduces the risk of "magical" side effects.

#### 3.2) Async in E1 (v1 policy)

- Reducer stays **pure**: no `Future` inside `reduce`.
- Async is done through **effects executor -> result events**:
  - effect launches an operation (with key/opId for dedup/cancel),
  - upon completion, the executor dispatches `Succeeded/Failed` events back to the reducer.

#### 3.3) Effects / Overlay / Listbox - mandatory v1 contracts

To avoid "Radix perf" and "overlay workarounds", we lock these in as v1 requirements:

- **Effects contract**: typed effect categories + executor with coalesce/dedupe/cancel + result events (see `docs/V1_DECISIONS.md`).
- **Overlay SLA**: anchoring on scroll/resize, nested scroll, flip/shift/collision, updates no more than 1/frame (see `docs/V1_DECISIONS.md`).
- **Listbox spec**: unified keyboard nav + typeahead rules (see `docs/V1_DECISIONS.md`).
