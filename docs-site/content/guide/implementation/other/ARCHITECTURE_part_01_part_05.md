## Monorepo Architecture (feature-first + DDD + SOLID) (part 1) (part 5)

Back: [Index](/guide/implementation/other/ARCHITECTURE_part_01)

---

### i18n policy (v1)

- Core provides a **contract** (`RenderlessStrings`/`RenderlessI18n`) and a scope for string overrides.
- Defaults are taken from `MaterialLocalizations` / `CupertinoLocalizations` where possible.
- This is **not** about "Material design in core": we use only strings, while visual defaults remain outside core.
- We don't put "30+ language" translations in core (if needed, a separate package later).

---

### Parts policy (v1)

- Renderer extension points are only **typed** (renderer contracts + slots `Replace/Decorate`).
- We don't use string-based part identifiers (analogue of `data-part`), to preserve type-safety and avoid "silently didn't work".

#### 4) "Transition interception" (analogue of `stateReducer`) - for product exceptions

For components where the product will inevitably request special rules:

- provide an optional hook: "here's the current state + proposed next state + event -> return the final next state"
- this allows customizing behavior **without forking** and without hacking internal fields

#### 5) What we DON'T do (important)

- We don't require the user to use `get_it`/`injectable`/`modularity_dart`/any DI as a mandatory part.
- We don't introduce a global store inside the design system.
- We don't force all components to live on one "shared" state manager.

#### 6) Where state lives in the package architecture

- **Theme (`ThemeScope`)**: theme state is decided at the application level (any state manager), the library provides only scope/contracts.
- **Interaction states** (hover/pressed/focus) and normalization are shared mechanisms in `headless_foundation`.
- **Component domain state** (e.g., selected value in a select) is controller/value in the component package.

---

### Important Nuances (must-haves for "library-level" quality)

#### Ownership and controller lifecycle (who disposes?)

- **Rule 1**: if a controller is passed from outside - **we don't dispose it**.
- **Rule 2**: if a controller is not passed - the component may create an internal controller and **must dispose it** on dispose.
- **Rule 3**: if an external controller changes between builds - the component correctly "re-subscribes" (without leaks and without double listeners).

This is the basic POLA contract: the user expects behavior like `TextField`/`ScrollController`.

#### Controlled/uncontrolled priority (to avoid surprises)

- If `value/state` or `controller` is provided - the component works in **controlled mode**.
- In controlled mode, internal state is allowed only as **derived** (e.g., computed state), but not as the source of truth.
- The component **must not** change `value` on its own without an explicit callback (`onChanged`) or without an event/contract.

#### Protection against sync cycles and UI "jitter"

When synchronizing external state and internal events, it's easy to get a cycle:
`onChanged -> parent sets value -> component triggers onChanged again`.

- It's important to have **stable comparison** (equality) for state/value and not emit events if "nothing changed".
- Any "normalization" (e.g., clamp, dedupe) must be **deterministic** and reflected in the API predictably.

#### Where state must not live (DDD discipline)

- `domain/` inside the component is specifications/contracts/invariants.
  **No** controllers, subscriptions, `ValueListenable`, overlay/focus logic.
- Reactivity and lifecycle belong in `presentation/`, `headless_foundation/` and `anchored_overlay_engine/`.

**Forbidden Flutter types in domain/application layers:**

| Category | Forbidden types | Alternative |
|----------|-----------------|-------------|
| **Widgets** | `Widget`, `State`, `BuildContext`, `Element` | - (only in presentation/) |
| **Rendering** | `Color`, `TextStyle`, `BoxDecoration` | Semantic tokens |
| **Events** | `PointerEvent`, `KeyEvent`, `TapDetails` | Abstract domain events |
| **Focus** | `FocusNode`, `FocusScopeNode` | Effects in foundation |
| **Animation** | `AnimationController`, `Ticker` | `AnimationPolicy` contract |
| **Overlay** | `OverlayEntry`, `OverlayState` | `OverlayController` in anchored_overlay_engine |
| **Gestures** | `GestureDetector`, `Listener` | `InteractionController` in foundation |

**CI check (local):**
```bash
# Domain and Application files DO NOT import package:flutter/*
grep -r "package:flutter" packages/*/lib/src/domain/
grep -r "package:flutter" packages/*/lib/src/application/
# Should return empty result
```

**CI Pipeline Integration (GitHub Actions):**

Add to `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  architecture-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check domain layer purity
        run: |
          echo "Checking domain layer for Flutter imports..."
          if grep -r "package:flutter" packages/*/lib/src/domain/ 2>/dev/null; then
            echo "::error::Flutter imports found in domain layer!"
            echo "Domain layer must not depend on Flutter types."
            echo "Use semantic tokens, abstract events, and foundation mechanisms."
            exit 1
          fi
          echo "✓ Domain layer is clean"

      - name: Check application layer purity
        run: |
          echo "Checking application layer for Flutter widget imports..."
          if grep -r "package:flutter/widgets" packages/*/lib/src/application/ 2>/dev/null; then
            echo "::error::Widget imports found in application layer!"
            exit 1
          fi
          if grep -r "package:flutter/material" packages/*/lib/src/application/ 2>/dev/null; then
            echo "::error::Material imports found in application layer!"
            exit 1
          fi
          echo "✓ Application layer is clean"

      - name: Check DAG (no circular dependencies)
        run: |
          echo "Checking for circular dependencies..."
          # Use dart pub deps to check
          cd packages/headless_foundation && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          cd ../headless_contracts && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          cd ../headless_theme && dart pub deps --no-dev 2>&1 | grep -i circular && exit 1 || true
          echo "✓ No circular dependencies"

  # ... remaining jobs (lint, test, build)
```

**CI invariants:**
- PR is not merged if domain layer contains Flutter imports
- PR is not merged if there are circular dependencies
- Automatic check on every push/PR

**Pre-commit hook (optional):**
```bash
#!/bin/bash
# .git/hooks/pre-commit

if grep -r "package:flutter" packages/*/lib/src/domain/ 2>/dev/null; then
  echo "ERROR: Flutter imports in domain layer"
  echo "Domain layer must be pure Dart."
  exit 1
fi
```

More on Domain Layer: see `V1_DECISIONS.md` -> "Domain Layer Invariants"

#### Bounded Contexts (DDD)

| Context | Entities | Domain Events | Value Objects | Invariants |
|---------|----------|---------------|---------------|------------|
| **Button** | `ButtonState` | `Pressed`, `Released` | `ButtonSpec`, `ButtonVariant`, `ButtonSize` | Button cannot be both pressed and disabled |
| **Menu/Listbox** | `MenuState`, `ListboxState` | `MenuOpened`, `ItemHighlighted`, `ItemSelected`, `MenuClosed` | `ListboxItemMeta` (id, label, disabled) | Only one item can be highlighted at a time |
| **Overlay** | `OverlayEntry` | `OverlayOpened`, `OverlayClosing`, `OverlayClosed` | `OverlayAnchor`, `FocusPolicy`, `DismissPolicy` | Overlay must complete close within timeout |
| **Interaction** | `InteractionController` | `PressStart`, `PressEnd`, `PressCancel`, `HoverEnter`, `HoverExit` | `PointerType`, `WidgetStateSet` | Pointer type determines feedback behavior |
| **Dialog** | `DialogState` | `DialogOpened`, `DialogClosing`, `DialogDismissed` | `DialogSpec`, `DialogRole` | Modal dialogs trap focus until closed |

**Context rules:**
- Each context owns its own entities and events
- Communication between contexts happens through effects or shared foundation
- Circular dependencies between contexts are not allowed

#### Ubiquitous Language (glossary of terms)

| Term | Definition | Where used |
|------|------------|------------|
| **highlighted** | Visually highlighted during navigation (keyboard) | Menu, Listbox, Select |
| **selected** | Selected value (controlled state) | Select, Listbox, RadioGroup |
| **pressed** | Pressed (pointer down, Space/Enter) | Button, MenuItem, all interactive elements |
| **focused** | Has keyboard focus | All focusable elements |
| **hovered** | Cursor is over the element | Button, MenuItem, Link |
| **disabled** | Inactive, does not respond to input | All interactive elements |
| **closing** | Exit animation is playing | Overlay, Dialog, Menu |
| **opening** | Enter animation is playing | Overlay, Dialog, Menu |
| **spec** | Value object with component parameters | All components |
| **renderer** | Responsible for visual output | Theme layer |
| **capability** | Set of capabilities for a group of components | Theme layer |
| **effect** | Side effect from reducer (focus, overlay, announce) | Foundation, Components |
| **slot** | Extension point for component structure | Dialog, Dropdown, Select |
| **anchor** | Reference for overlay positioning | Overlay, Dropdown, Tooltip |

**Invariant:** `highlighted` != `selected`. Highlight is a temporary visual state during navigation, selection is a chosen value.

#### StateReducer (transition interception) - safety rules

- The hook must not allow "breaking invariants" of the component (e.g., returning an impossible state).
- The component must correctly handle "weird" reduces: no crashes, no infinite transitions.
- Document which events the reducer can modify and which state fields are considered "owned by component" (if any).

#### Performance (important for headless)

- Minimize rebuild count: subscriptions and listeners should be targeted.
- Don't bloat state: store only what's needed for behavior/a11y, the rest is in renderer/style resolve.

---

### Policy: context splitting (to avoid "re-render storms")

Problem from the ecosystem (compound components/context): when a value is recreated on every build, all consumers re-render, and performance degrades.

**Rule for Headless:**
- In `Scope`/contexts **don't pass** "large" value objects that are recreated every build.
- Prefer:
  - `ValueListenable`/`Listenable` + targeted `ValueListenableBuilder`
  - `InheritedNotifier` (or similar pattern), so only subscribers to the specific notifier update
- For overlay/listbox it's important to separate:
  - "open/close state"
  - "highlight/selection state"
  - "positioning state"
  so that the entire subtree doesn't rebuild on every highlight/scroll movement.
