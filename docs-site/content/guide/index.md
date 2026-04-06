# Headless Guide

Build Flutter UI with consistent behavior, accessibility, and fully swappable visuals. This hub links every guide, recipe, and reference you need.

## Learning Path

Follow these steps to go from zero to production:

1. **[Why Headless?](/guide/headless_workspace/WHY_HEADLESS)** - understand the architecture and when it makes sense
2. **[Users Guide](/guide/headless_workspace/users/README)** - install, configure, and build your first app
3. **[Recipes](/guide/headless_workspace/users/COOKBOOK)** - common patterns and a hands-on cookbook
4. **[Customize](/guide/headless_workspace/users/GUARDRAILS)** - style tweaks, slots, scoped themes, and guardrails

## Getting Started

:::tip First time here?
Head straight to the **[Users Guide](/guide/headless_workspace/users/README)** for a step-by-step walkthrough covering installation, renderer setup, and your first component.
:::

## Recipes

| Recipe | What you will find |
|---|---|
| [Common Recipes](/guide/headless_workspace/users/COOKBOOK) | Buttons, inputs, dropdowns, and everyday patterns |
| [TextField Recipes](/guide/headless_workspace/users/COOKBOOK_TEXTFIELD) | Validation, formatting, and controller wiring |
| [Autocomplete Recipes](/guide/headless_workspace/users/COOKBOOK_AUTOCOMPLETE) | Async data sources, filtering, and custom layouts |
| [Advanced Patterns](/guide/headless_workspace/users/COOKBOOK_ADVANCED) | Scoped overrides, custom renderers, and large-app strategies |

## Reference

- [Guardrails](/guide/headless_workspace/users/GUARDRAILS) - safe customization boundaries and what to avoid
- [Changelog](/guide/headless_workspace/CHANGELOG) - what changed between versions

:::info Key Concepts
- **Behavior vs Visuals** - Headless separates what a component does (focus, keyboard, state, a11y) from how it looks. Behavior lives in `headless_foundation`; visuals are pluggable.
- **Renderers** - a renderer decides the structure and appearance. Headless ships Material 3 and Cupertino presets, and you can create your own.
- **Customization levels** - Style (quick visual tweaks) -> Slots (per-instance structure) -> Scoped Theme (subtree overrides) -> Custom Renderer (full control).
:::
