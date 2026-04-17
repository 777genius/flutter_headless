# Private Research: Popular Flutter Widgets for Headless Adaptation

Date: 2026-04-10

## Goal

Select a popular Flutter UI package that is worth adapting into the Headless architecture:

- behavior separated from visuals
- renderer capability driven
- suitable for Material, Cupertino, and custom rendering
- strong enough to demonstrate Headless value to the community

## Repo Context

This repository already has strong coverage for:

- buttons
- checkboxes
- switches
- text fields
- dropdowns
- autocomplete

The strongest differentiator of the architecture is not "styled widgets", but:

- focus and keyboard behavior
- a11y semantics
- overlay behavior
- state and token resolution
- renderer and capability split

Because of that, the best candidates are components where behavior matters more than paint.

## Shortlist

### 1. modal_bottom_sheet

Score: 🎯 9   🛡️ 8   🧠 8
Estimated change size: 1600-2600 lines

Links:

- https://pub.dev/packages/modal_bottom_sheet
- https://github.com/jamesblasco/modal_bottom_sheet

Observed signals on 2026-04-10:

- pub.dev: 3.5k likes, 267k downloads, version 3.0.0
- GitHub: 2k stars

Why it fits:

- strong interaction model
- drag to close
- nested navigation
- modal and non-modal behavior
- platform-specific visual mapping

Why it is valuable for Headless:

- excellent showcase of overlay contracts
- excellent showcase of dismiss policies and focus policies
- renderer split is meaningful

Main risk:

- upstream package is mature but not very fresh
- parity scope is large

Verdict:

- best architecture showcase
- not the fastest implementation

### 2. table_calendar

Score: 🎯 9   🛡️ 9   🧠 8
Estimated change size: 1800-3000 lines

Links:

- https://pub.dev/packages/table_calendar
- https://github.com/aleksanderwozniak/table_calendar

Observed signals on 2026-04-10:

- pub.dev: 3.3k likes, 479k downloads
- GitHub: 2k stars

Why it fits:

- rich interaction and state rules
- range selection
- focused day management
- event loading
- locale-sensitive behavior

Why it is valuable for Headless:

- clean separation between calendar logic and cell rendering
- strong candidate for render request + typed item model

Main risk:

- date logic and locale details expand scope quickly

Verdict:

- excellent component for a future headless adaptation
- more complex than it first appears

### 3. flutter_slidable

Score: 🎯 8   🛡️ 8   🧠 9
Estimated change size: 1400-2400 lines

Links:

- https://pub.dev/packages/flutter_slidable
- https://github.com/letsar/flutter_slidable

Observed signals on 2026-04-10:

- pub.dev: 6.1k likes, 539k downloads, Flutter Favorite
- GitHub: 2.9k stars

Why it fits:

- gesture-heavy behavior
- action panes
- dismiss contract
- rich motion behavior

Why it is valuable for Headless:

- strong demonstration of state/gesture/render split
- could create reusable swipeable foundation primitives

Main risk:

- gesture coordination and physics increase implementation cost

Verdict:

- strong future candidate
- harder to make robust than it looks

## Selected Package: pinput

Links:

- https://pub.dev/packages/pinput
- https://github.com/Tkko/Flutter_PinPut

Observed signals on 2026-04-10:

- pub.dev: version 6.0.2, published 2 months ago
- pub.dev: 3.45k likes, 439k downloads
- GitHub: 852 stars
- License: MIT

Score: 🎯 8   🛡️ 9   🧠 6
Estimated change size: 900-1400 lines

## Why pinput was selected

`pinput` is the best balance between:

- real popularity
- fresh maintenance
- compact implementation scope
- enough behavioral richness to prove the Headless model

It already includes behavior worth preserving:

- completion detection
- validation
- per-cell state mapping
- hidden editable text ownership
- clipboard integration
- autofill hooks
- haptic feedback hooks
- obscure mode
- optional native keyboard usage
- cursor and animation policies

At the same time, it is still small enough to adapt with high quality.

## Important adaptation principle

The upstream package stores too much visual meaning inside `PinTheme` and widget composition.

For the Headless version, we should preserve:

- behavior
- state machine
- input policies
- per-cell state mapping
- variant intent

But move out:

- cell visuals
- borders
- shadows
- cursor widget visuals
- built-in decorative themes

Those should live in:

- renderer capability
- token resolver
- per-instance overrides
- optional local preset/demo renderers

## Variant Strategy

The original package exposes multiple styling families through theme examples rather than a clean variant API.

For the Headless adaptation, the recommendation is:

- preserve these families as typed variant intent
- do not preserve hardcoded `PinTheme` visuals
- let renderers interpret the intent

This keeps the familiarity of the upstream package while staying aligned with Headless principles.

## Recommended Tooling for Runtime and Visual QA

### Chosen tool: Marionette MCP

Links:

- https://github.com/leancodepl/marionette_mcp
- https://pub.dev/packages/marionette_cli

Why it was chosen:

- purpose-built for runtime interaction with Flutter apps
- minimal app integration
- supports tap, text entry, scroll, screenshots, and video-oriented flows
- explicitly positioned for runtime interaction rather than general development tooling
- also provides a CLI, which is practical in local automation workflows
- observed repository package versions on 2026-04-10:
  - `marionette_flutter`: 0.5.0
  - `marionette_cli`: 0.5.0

Relevant repository note:

- the Marionette README directly compares itself with the official Dart and Flutter MCP server and states that Marionette is optimized for runtime interaction, while the official server is stronger for development-time tasks

### Compared tool: mcp_flutter

Link:

- https://github.com/Arenukvern/mcp_flutter

Why it was not chosen as the main runtime QA tool:

- useful and interesting
- broader "dynamic tooling" angle
- less focused than Marionette for direct visual smoke testing workflows

### Practical conclusion

For this task:

- use the local Flutter SDK and standard Flutter tests for fast regression coverage
- use Marionette for runtime smoke validation and screenshots

This gives the best balance of:

- reliability
- visual confidence
- speed

## Final Recommendation

If we want a fast but impressive community-facing adaptation, `pinput` is the right first package.

It is:

- popular enough to matter
- fresh enough to feel relevant
- behavior-rich enough to showcase Headless architecture
- compact enough to complete with strong quality
