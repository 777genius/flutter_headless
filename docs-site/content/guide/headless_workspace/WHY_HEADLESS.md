---
sidebar_position: 1
sidebar_label: "Why Headless?"
---
### Why Headless when you can "just write your own widgets"?

This document answers the question: **why Headless makes sense as a library**, even though Flutter makes it easy to customize UI and write your own components.

Related documents:
- `docs/MUST.md` - key improvements and principles.
- `docs/ARCHITECTURE.md` - target architecture: monorepo + DDD + SOLID.
- `docs/SPEC_V1.md` - specification for compatible components/packages.
- `docs/CONFORMANCE.md` - how to declare Headless compatibility and the minimum checks required.

---

### The core idea

**Headless is not "a set of buttons".**  
Headless is a **system of contracts and mechanisms** that lets you:

- maintain **consistent behavior** and a **unified design language** across a team/product at scale,
- change visuals/branding **without forks or copy-paste**,
- avoid "magic" and unexpected side effects (POLA),
- verify correctness through behavioral tests rather than pixel comparisons.

You can always write custom widgets. The real question is **what does maintenance cost** and **how predictable** the system remains after 6-12 months.

---

### Real problems Headless solves

#### 1) UI consistency at scale

When everyone writes their "own" widgets, inconsistencies creep in fast:

- different states (hover/pressed/focus/disabled) implemented differently,
- different sizes/touch targets,
- different focus and keyboard "rules",
- different spacing and typography,
- different contracts (sometimes `isLoading`, sometimes `loading`, sometimes a separate `Spinner`).

Headless locks down the **contract** (variants/spec/state/resolved) and makes inconsistencies "harder to introduce by accident".

#### 2) Multi-brand / white-label without code branching

"Customizing a widget" in an app often ends up as:

- `if (brand == ...)` inside the UI,
- duplicated components like `ButtonA/ButtonB`,
- copying files "per brand".

Headless lets you keep **a single component** and swap:

- tokens (raw + semantic),
- state policies,
- renderer (structure/visuals),

without touching business code or creating parallel implementations.

#### 3) POLA (Principle of Least Astonishment) as a systemic rule

In a UI system, the expensive part is not "drawing" but "not surprising".

Headless enforces predictability:

- controlled/uncontrolled model (like `TextField`),
- clear defaults (disabled/loading/focus),
- no hidden side effects (no stealing focus / no closing overlays "by magic"),
- unified state priority rules.

#### 4) Complex components and edge cases

Complex interactive components (`Select/Menu/Combobox/Dialog`) break not on the happy path but at the edges:

- focus trapping and focus return,
- keyboard navigation,
- closing on outside click / Esc,
- nested overlays,
- scroll/positioning,
- event contention (gesture vs focus vs dismiss).

Headless extracts shared mechanisms into `foundation` (overlay/focus/FSM/state resolution) so that behavior is uniform across all components.

#### 5) Testing at the right level

In the headless approach, what matters is testing **behavior**, not pixels:

- state transitions,
- callback correctness,
- a11y semantics,
- keyboard scenarios,
- state invariants.

When everyone writes their widgets "however it works", tests become fragmented and regressions become inevitable.

#### 6) API stability and library scalability

A "set of custom widgets" typically evolves chaotically.

Headless (see `docs/ARCHITECTURE.md`) relies on:

- capability contracts (ISP) instead of a single giant interface,
- renderer contracts for visuals,
- lockstep SemVer for monorepo packages,
- deprecation policy instead of sudden breaking changes.

---

### Lessons from the web ecosystem (2025-2026) that apply here

In the web world, headless UI often depends on hooks/render-props and runs into server/client boundaries (e.g., React Server Components).  
Flutter doesn't have that split, but the lesson still applies: **don't build core APIs on fragile runtime mechanisms**. That's why Headless defines behavior through clean contracts (events/state/effects) and renderer contracts rather than "magical" patterns.

---

### What Headless does NOT do (and why that matters)

- **Does not impose a state manager** (Riverpod/BLoC/MobX) - the library must be compatible with all approaches.
- **Does not impose DI** (`get_it/injectable/modularity_dart`) - DI stays at the application level.
- **Does not try to be "yet another Material"** - the goal is not "a set of pretty ready-made components" but an architecture for different brands and systems.

---

### DX today (in brief)

To lower the barrier to entry without sacrificing headless architecture:
- there is **simple sugar** (`style: R*Style`) that compiles into overrides,
- there are **theme defaults** (`MaterialHeadlessDefaults`) for common policies,
- there is **Headless*Scope** for local capability overrides,
- documentation is split into Users/Contributors + golden path.

---

### When Headless is NOT needed (honestly)

Headless can be overkill if:

- single brand,
- small team,
- no requirements for a11y/keyboard/overlay complexity,
- UI changes rarely and is not a product differentiator,
- you don't plan to maintain a design system as a library.

---

### When Headless is especially justified

Headless delivers maximum ROI when:

- 2+ brands (white-label) or different product lines,
- multiple teams building UI in parallel,
- many complex components (select/menu/dialog),
- POLA and predictable behavior are important,
- the library needs to live for years without "archaeology" and rewrites.

---

### Practical check: is it worth it for your team?

If you answer "yes" to most of these, Headless will almost certainly pay off:

- Our implementations of the same components regularly diverge.
- We've already made copies "per brand" or added conditional branches by brand.
- We frequently hit regressions in states/focus/overlays.
- We want to ship new components faster and more predictably.
- We want an architecture where "the right way" is easier than "the accidental way".
