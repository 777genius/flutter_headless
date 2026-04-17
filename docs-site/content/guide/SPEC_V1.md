## Headless Component Spec v1

**Status:** Draft (may be refined/extended before the first v1 release, but changes are made deliberately and preserving POLA).

Goal: create a **single, verifiable standard** by which third-party authors can build compatible headless components/packages for Flutter/Dart and share them with the community.

This document is **normative**. It describes requirements at the "MUST/SHOULD/MAY" level.

### Important for community (external repositories)

- Packages **are not required to copy** `docs/` from this repository.
- When claiming compatibility, a package **references upstream**: a specific release/tag/commit where `docs/SPEC_V1.md` and `docs/CONFORMANCE.md` are published.

### How this differs from other documents

- `docs/ARCHITECTURE.md`: architecture of **this repository** (package boundaries, dependency rules, policy).
- `docs/v1_decisions/V1_DECISIONS.md`: documented **v1 decisions for core contracts** (overlay/listbox/effects/theme/tokens) and invariants that compatibility relies on.
- `docs/SPEC_V1.md` (this file): requirements for **third-party packages** to be "Headless-compatible".
- `docs/CONFORMANCE.md`: how exactly a package **claims compatibility** and what minimum set of checks/tests is required.

### Terms

- **Component package**: a publishable component package (e.g., `packages/components/headless_<feature>` in this repository) that provides `R*` widgets/controllers and uses core contracts.
- **Core contracts**: packages `headless_tokens`, `headless_foundation`, `headless_contracts`.
- **Renderer capability**: a renderer/theme capability interface that `R*` requires through capability discovery.
- **Conformance**: a set of checks/tests confirming compliance with Spec v1.

### Non-goals

- Spec v1 **does not** standardize visuals or "Material-by-default".
- Spec v1 **does not** impose an application state manager (Riverpod/BLoC/MobX/Redux).
- Spec v1 **does not** require Navigator/Route for overlay patterns.

---

## 1) Component package requirements (mandatory)

### 1.1 Public API and naming

- **MUST**: public widgets of a headless component are named `R*` (Flutter-like POLA, no name conflicts).
- **MUST**: the package must have a clearly defined "entrypoint" (`lib/<package>.dart`) and export only the public API.
- **MUST NOT**: use or document imports of internal files `package:<pkg>/src/...` as a public usage method.
- **SHOULD**: cross-package imports should go through the entrypoint (`package:<pkg>/<pkg>.dart`) whenever possible - this simplifies migrations and reduces the risk of breakages.
- **SHOULD**: public API should be minimal, extension - through optional parameters/slots/capabilities.

### 1.2 Layer structure (DDD/Clean Architecture within the package)

A component package **MUST** be organized at minimum as follows:

```text
lib/
  src/
    domain/            # if needed (value objects, events, variants)
      variants/
      specs/
      resolved/        # if needed (but without UI types)
    presentation/
      widgets/         # R* widgets and glue for behavior/a11y
      controllers/     # controllers/value listenables (if any)
    infra/
      adapters/        # integration with theme/foundation (no baseline UI)
```

- **MUST**: `domain/` does not depend on Flutter UI types (see `docs/ARCHITECTURE.md` - "Where state must not be stored").
- **MUST**: `presentation/` is responsible for behavior/states/a11y and spec/state assembly.
- **MUST NOT**: store baseline visuals inside the component; visuals are delegated to the renderer through `headless_contracts` (capability discovery - via `headless_theme`).

#### Minimal package (exception for simple components)

For very simple v1 components (e.g., Button), where:
- there is no domain model beyond a few enums/parameters,
- there is no separate infrastructure beyond direct capability access,

it is acceptable to **not create empty `domain/` and/or `infra/` directories**.

Invariants still hold:
- headless separation is maintained,
- public API is stable and minimal,
- no import of renderer implementations,
- conformance tests are present.

### 1.3 Dependencies (DAG)

- **MUST**: a component package **does not** depend on other component packages (`packages/components/*` policy).
- **MUST**: dependencies conform to the table from `docs/ARCHITECTURE.md` ("what can import what").
- **MUST**: the package dependency graph remains a DAG (no cycles).

---

## 2) Headless contract: behavior separate from visuals

### 2.1 Renderer contract and capability discovery

- **MUST**: an `R*` component obtains the renderer capability from the theme/composition (capability discovery), and does not import specific renderer implementations.
- **MUST**: absence of a capability must result in clear diagnostics (assert/throw with instructions for connecting).

See `docs/v1_decisions/V1_DECISIONS.md`:
- 0.1 Renderer contracts
- "Absence of a renderer = explicit error"

### 2.1.1 Scoped capability overrides (SHOULD)

- **SHOULD**: applications/presets can override renderer/token resolver capabilities on a subtree through theme composition (nested theme scopes).
- **SHOULD**: override behavior must be POLA: override-wins, otherwise fallback to the base theme.
- **MUST NOT**: require "theme merging" as mandatory semantics (no auto-merge of preset configs).
- **SHOULD**: capability contracts used for discovery should be non-generic (stable type identity).
- **SHOULD**: HeadlessTheme provides a capability for motion tokens (e.g. `HeadlessMotionTheme`), and renderers respect resolved motion tokens with priority: per-instance -> motion capability -> preset defaults.

### 2.1.2 App-level motion theme (SHOULD)

Goal: give people one clear "lever" for unified animation durations/curves at the application level, without modifying renderers.

- **SHOULD**: applications can provide `HeadlessMotionTheme` as a capability and override it on a subtree.
- **MUST**: the renderer must respect motion tokens in resolved tokens.
- **MUST**: motion resolution priority (high to low):
  - per-instance motion tokens (`resolvedTokens.*.motion`, if set),
  - `HeadlessMotionTheme` capability (app/subtree),
  - preset defaults (e.g., `HeadlessMotionTheme.material`/`HeadlessMotionTheme.cupertino`).

Example: globally set a motion profile for the entire application:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(),
  child: HeadlessThemeOverridesScope.only<HeadlessMotionTheme>(
    capability: const HeadlessMotionTheme.standard(),
    child: MaterialApp(
      home: MyApp(),
    ),
  ),
)
```

Example: locally "speed up" motion on a single screen only:

```dart
HeadlessThemeOverridesScope.only<HeadlessMotionTheme>(
  capability: const HeadlessMotionTheme(
    dropdownMenu: RDropdownMenuMotionTokens(
      enterDuration: Duration(milliseconds: 120),
      exitDuration: Duration(milliseconds: 120),
      enterCurve: Curves.easeOut,
      exitCurve: Curves.easeOut,
      scaleBegin: 0.97,
    ),
    button: RButtonMotionTokens(
      stateChangeDuration: Duration(milliseconds: 120),
    ),
  ),
  child: SettingsScreen(),
)
```

### 2.1.3 Tokens-only visual parameters (MUST)

- **MUST**: the renderer **does not** compute visual parameters from constants; all values are taken from `resolvedTokens`.
- **MUST**: for transparent surfaces, opacity is stored as a separate token (to avoid losing `CupertinoDynamicColor`).

### 2.1.4 Strict tokens policy (MAY)

- **MAY**: an application can provide a `HeadlessRendererPolicy` capability with `requireResolvedTokens=true`,
  to crash in debug/test mode when `resolvedTokens` are missing.

Example:

```dart
HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
  capability: const HeadlessRendererPolicy(requireResolvedTokens: true),
  child: const HeadlessMaterialApp(home: Placeholder()),
)
```

Example (dropdown menu):
- `backgroundOpacity`, `backdropBlurSigma`, `shadowColor`, `shadowBlurRadius`, `shadowOffset`.

### 2.2 Slots/Parts for targeted override

- **SHOULD**: complex components provide typed slots/parts (Replace/Decorate/Enhance) as the primary mechanism for customizing structure.
- **MUST NOT**: use string-based part identifiers.

See `docs/v1_decisions/V1_DECISIONS.md` - "Slots override: Replace + Decorate".

### 2.3 Interaction boundaries (no "gray zones") - MUST

Goal: the same `R*` component must have **identical behavior** across any renderers (Material/Cupertino/custom), otherwise headless separation loses its purpose.

- **MUST**: the component owns root interaction and root accessibility.
  - The root activation surface (e.g., button/trigger) handles pointer/keyboard through `headless_foundation` (e.g., `HeadlessPressableRegion`).
  - Root Semantics (`button`, `enabled`, `expanded`, label, etc.) are set by the component, not the renderer.
- **MUST NOT**: the renderer must not invoke "user callbacks" of the application (e.g., `onPressed`, `onChanged`) and must not create a second independent activation path.
  - Prohibited: `InkWell(onTap: ...)` / `GestureDetector(onTap: ...)` on the root surface if it leads to activation.
  - Reason: this creates double-invoke and/or behavior divergence between renderers.
- **MAY**: the renderer may "wire up" only to **command** methods of the component that are passed in the render request.
  - This is not a "decision" but wiring UI to the component's command API.
  - Recommendation (SHOULD): distinguish by naming:
    - **User callbacks**: `on*` parameters of the `R*` widget (belong to the application).
    - **Commands**: imperative methods (`open()`, `close()`, `selectIndex(i)`, `highlight(i)`, `completeClose()`), which live in the render request and belong to the component.

---

## 3) State model: controlled/uncontrolled (POLA)

- **MUST**: if `value/state` or `controller` is provided - the component operates in controlled mode and does not "overwrite" state on its own.
- **MUST**: controller ownership - same as Flutter: an external controller is not disposed; an internal one - must be disposed.
- **SHOULD**: have protection against sync cycles (`onChanged -> parent sets value -> onChanged`) through equality/dedupe.

See `docs/ARCHITECTURE.md` - "Ownership and controller lifecycle".

---

## 4) Overlay/Listbox/Effects: mandatory integrations with core contracts

If a component uses overlay/menu patterns:

- **MUST**: use overlay infrastructure from `headless_foundation` (not Navigator).
- **MUST**: follow the close/phase contract (opening/open/closing/closed + `completeClose()` + fail-safe timeout).
- **MUST**: build keyboard navigation/typeahead on foundation listbox primitives (where applicable).
- **SHOULD**: structure side effects as effects (E1: events -> reducer -> effects executor), so the core remains pure.

See `docs/v1_decisions/V1_DECISIONS.md` - 0.2/0.3/0.7 and sections E1/A1.

---

## 5) Tests and Conformance

### 5.1 Minimum conformance set (v1)

A package claiming "compatible with Spec v1" **MUST** have tests covering:

- **A11y/semantics**: basic roles/label/disabled states.
- **Keyboard-only scenarios**: focus, Escape/Enter/Space, list navigation (if listbox is present).
- **Overlay lifecycle**: correct transition to `closing`, completion of `completeClose()`, fail-safe does not hang.
- **Controlled/uncontrolled**: correct behavior with external value/controller.

### 5.2 Where test helpers live

- **SHOULD**: use `headless_test` helpers (when they become available) instead of "hand-rolled" test utilities.

---

## 6) Versioning and compatibility

- **MUST**: the component specifies a compatible version range of core contracts (at least one MAJOR).
- **SHOULD**: follow the lockstep versioning of the system if the component is published as part of the "official set".

See `docs/ARCHITECTURE.md` - "Versioning policy (SemVer)".

---

## 7) Metadata for AI/generators (LLM.txt)

- **MUST**: a publishable package contains `LLM.txt` at the root (Purpose/Non-goals/Invariants/Correct usage/Anti-patterns).
- **MUST**: when changing the public API/invariants, update `LLM.txt` in the same PR.

See `docs/ARCHITECTURE.md` - "AI/MCP metadata policy (LLM.txt)".
