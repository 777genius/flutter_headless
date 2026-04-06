---
sidebar_position: 1
sidebar_label: "Why Headless?"
---

### Why Headless, when you can "just write your own widgets"?

This document answers the question: **why Headless makes sense as a library**, even though Flutter makes it easy to customize UI and write your own components.

Related documents:
- `docs/MUST.md` - key improvements and principles.
- `docs/ARCHITECTURE.md` - target architecture: monorepo + DDD + SOLID.
- `docs/SPEC_V1.md` - specification for compatible components/packages.
- `docs/CONFORMANCE.md` - how to declare Headless compatibility and minimum checks.

---

### The Core Idea

**Headless is not "a set of buttons".**  
Headless is a **system of contracts and mechanisms** that allows you to:

- maintain **consistent behavior** and a **unified design language** across a team/product,
- change visuals/branding **without forks or copy-paste**,
- avoid "magic" and unexpected side effects (POLA),
- verify correctness through behavioral tests, not pixel comparisons.

You can always write custom widgets. The question is **what the maintenance cost is** and **how predictable** the system will remain in 6-12 months.

---

### What Real Problems Headless Solves

#### 1) UI Consistency at Scale

When everyone writes "their own" widgets, discrepancies appear quickly:

- different states (hover/pressed/focus/disabled) implemented differently,
- different sizes/touch targets,
- different focus and keyboard "rules",
- different spacing and typography,
- different contracts (sometimes `isLoading`, sometimes `loading`, sometimes a separate `Spinner`).

Headless locks down the **contract** (variants/spec/state/resolved) and makes discrepancies "harder to introduce accidentally".

#### 2) Multi-brand / White-label Without Code Branching

"Customizing a widget" in an app often ends up as:

- `if (brand == ...)` inside the UI,
- duplicate components `ButtonA/ButtonB`,
- copying files "per brand".

Headless lets you keep **one component** and change:

- tokens (raw + semantic),
- state policies,
- renderer (structure/visuals),

without touching business logic or creating parallel implementations.

#### 3) POLA (Principle of Least Astonishment) as a Systemic Rule

In a UI system, the hard part is not "drawing" but "not surprising users".

Headless enforces predictability:

- controlled/uncontrolled model (similar to `TextField`),
- clear defaults (disabled/loading/focus),
- no hidden side effects (no focus changes or overlay dismissals "by magic"),
- unified state priority rules.

#### 4) Complex Components and Edge Cases

Complex interactive components (`Select/Menu/Combobox/Dialog`) break not in the happy path, but at the edges:

- focus trapping and focus return,
- keyboard navigation,
- dismissal on outside click/esc,
- nested overlays,
- scroll/positioning,
- event conflicts (gesture vs focus vs dismiss).

Headless extracts shared mechanisms into `foundation` (overlay/focus/FSM/state resolution), so behavior is uniform across all components.

#### 5) Testing at the Right Level

In a headless approach, it is critical to test **behavior**, not pixels:

- state transitions,
- callback correctness,
- a11y semantics,
- keyboard scenarios,
- state invariants.

When everyone writes widgets "however they see fit", tests become fragmented and regressions become inevitable.

#### 6) API Stability and Library Scalability

A "set of custom widgets" usually evolves chaotically.

Headless (see `docs/ARCHITECTURE.md`) relies on:

- capability contracts (ISP) instead of one giant interface,
- renderer contracts for visuals,
- lockstep SemVer for monorepo packages,
- deprecation policy instead of sudden breaking changes.

---

### Lessons from the Web Ecosystem (2025-2026) That Apply to Us

In the web world, headless UI often depends on hooks/render-props and runs into server/client boundaries (e.g., React Server Components).  
Flutter does not have this split, but the lesson is important: **don't build core APIs on fragile runtime mechanisms**. That is why Headless captures behavior through clean contracts (events/state/effects) and renderer contracts, rather than "magical" patterns.

---

### What Headless Does NOT Do (and Why That Matters)

- **Does not impose a state manager** (Riverpod/BLoC/MobX) - the library must be compatible with all approaches.
- **Does not impose a DI framework** (`get_it/injectable/modularity_dart`) - DI stays at the application level.
- **Does not try to be "yet another Material"** - the goal is not to "ship a set of pretty ready-made components", but to provide an architecture for different brands and design systems.

---

### Developer Experience Today (Brief)

To lower the barrier to entry without sacrificing headless architecture:
- there is **simple sugar** (`style: R*Style`) that compiles into overrides,
- there are **theme defaults** (`MaterialHeadlessDefaults`) for common policies,
- there is **Headless*Scope** for locally swapping capabilities,
- documentation is split into Users/Contributors + golden path.

---

### When Headless is Not Needed (Honestly)

Headless can be overkill if:

- single brand,
- small team,
- no a11y/keyboard/overlay complexity requirements,
- UI changes rarely and is not a product differentiator,
- you don't plan to maintain a design system as a library.

---

### When Headless is Especially Worthwhile

Headless delivers the highest ROI when:

- 2+ brands (white-label) or different product lines,
- multiple teams are building UI in parallel,
- many complex components (select/menu/dialog),
- POLA and predictable behavior matter,
- the library needs to live for years without "archaeology" and rewrites.

---

### Practical Check: Is It Worth It for Your Team?

If you answer "yes" to most of these, Headless will almost certainly pay for itself:

- Our implementations of identical components regularly drift apart.
- We have already made copies "per brand" or conditional branches by brand.
- We frequently experience regressions in states/focus/overlays.
- We want to ship new components faster and more predictably.
- We want an architecture where "the right way" is easier than "the accidental way".
