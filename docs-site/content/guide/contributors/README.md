# Contributors Guide

This guide is for building new components, presets, or modifying core behavior.
If you are a library user, use `docs/users/README.md`.

## Canonical references

- Architecture: `docs/ARCHITECTURE.md`
- V1 decisions: `docs/V1_DECISIONS.md`
- Spec (normative): `docs/SPEC_V1.md`
- Conformance (normative): `docs/CONFORMANCE.md`
- Policies and invariants: `docs/MUST.md`
- DX simplification plan: `docs/implementation/I25_user_dx_simplification_v1_2.md`
- Golden path: `docs/contributors/GOLDEN_PATH_COMPONENT.md`

## Golden rules

- Keep component behavior separate from rendering (capability contracts).
- Follow the DAG: no component-to-component dependencies.
- Preserve single activation source in components.
- Per-instance visuals go through overrides or style sugar (no new API layers).
- Use conformance tests for behavior and a11y.

## Where to add things

- Component packages: `packages/components/*`
- Contracts and tokens: `packages/headless_contracts`, `packages/headless_tokens`
- Presets: `packages/headless_material`, `packages/headless_cupertino`
- Theme runtime: `packages/headless_theme`
- Foundation primitives: `packages/headless_foundation`

## Recommended workflow

- Start from the spec and conformance requirements.
- Add renderer and token resolver capabilities.
- Add tests: behavior, a11y, tokens, and conformance.
- Update docs and LLM.txt for the component package.
