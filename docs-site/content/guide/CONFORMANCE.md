## Conformance (Headless compatibility) — v1

This document defines **how exactly** a package claims Headless compatibility.

### What counts as "Headless-compatible"

A package is considered compatible only if it:

- fulfills the requirements of `docs/SPEC_V1.md`,
- adheres to v1 contracts from `docs/v1_decisions/V1_DECISIONS.md` (for the parts it uses),
- has a minimum set of tests (see below).

If any of these are not met, the package **should not** be called "Headless-compatible".

---

## 1) Minimum conformance checklist (MUST)

### 1.1 Structure and dependencies

- **MUST**: no dependency on other components (`packages/components/*`).
- **MUST**: `domain/` does not import `package:flutter/*`.
- **MUST**: public API is minimal; no leakage of renderer implementation.

### 1.2 Headless separation

- **MUST**: `R*` is responsible for behavior/states/a11y, while visuals are delegated to a renderer capability (`headless_contracts`).
- **MUST**: absence of a renderer capability produces a clear diagnostic error.

### 1.2.1 Scoped capability overrides (SHOULD)

- **SHOULD** (for preset/theme packages): there is a test verifying that subtree-override capability works:
  - base theme provides capability X;
  - subtree overrides X;
  - lookup inside subtree returns the override.

### 1.3 Controlled/uncontrolled and ownership

- **MUST**: controlled mode is not overwritten by internal state.
- **MUST**: an external controller is not disposed by the component; an internal one is disposed.

### 1.4 Overlay/Listbox/Effects (if applicable)

If the component uses an overlay/menu pattern:

- **MUST**: overlay via `headless_foundation`, without Navigator/Route.
- **MUST**: lifecycle phase contract is followed (`opening/open/closing/closed`) along with `completeClose()` + fail-safe.
- **MUST**: close contract (renderer <-> overlay host) is formalized and tested:
  - **MUST**: transition to `closing` means "close has started".
  - **MUST**: `callbacks.onCompleteClose()` is called **exactly once** for each "real" close.
  - **MUST**: if `closing` is **cancelled** (phase returned to `open/opening` before animation completed), `onCompleteClose()` is **not** called.
  - **MUST**: if widget/renderer **disposal** occurs during `closing`, `onCompleteClose()` still **MUST** be called (fail-safe, so the overlay doesn't "hang").
- **MUST**: keyboard navigation and typeahead (if a list is present) are implemented via foundation listbox primitives or equivalently meeting their invariants.

### 1.5 AI metadata

- **MUST**: publishable package contains `LLM.txt` (Purpose / Non-goals / Invariants / Correct usage / Anti-patterns).
- **SHOULD**: if a package claims compatibility, README links to upstream `docs/SPEC_V1.md` and `docs/CONFORMANCE.md` at a specific tag/commit (not `main`).

---

## 2) Minimum test set (MUST)

A package must have tests that verify:

- **Semantics/a11y**: roles/labels/disabled for key states.
- **Keyboard-only**: basic focus and activation scenarios (Space/Enter/Escape).
- **Controlled/uncontrolled**: correct behavior with external `value/controller`.
- **Overlay** (if applicable): `close()` transitions to `closing`, and completion happens via `completeClose()`; fail-safe prevents "hanging".

---

## 3) How to claim compatibility

- **SHOULD**: explicitly state in the package README that the package conforms to Spec v1, and provide links to `docs/SPEC_V1.md` and `docs/CONFORMANCE.md`.
- **SHOULD**: describe which parts of v1 contracts the package uses (overlay/listbox/effects).

### 3.1 Recommended wording for README (copy-paste)

```text
Compatibility: Conforms to Headless Spec v1 (see upstream docs/SPEC_V1.md), passes conformance (see upstream docs/CONFORMANCE.md).
```

---

## 4) "Passes conformance" format (verifiable report) — MUST

If a package claims "passes conformance", it **MUST** provide a text report in the package repository that can be verified.

**Important:** for community packages that live in separate repositories, links to Spec/Conformance should point to upstream (this repository) and be pinned to a specific release/tag/commit.

### 4.1 Where to store the report

- **MUST**: a `CONFORMANCE_REPORT.md` file at the package root **or** a "Conformance Report" section in the package README.

### 4.2 Minimum report contents (MUST)

The report **MUST** contain:

- **Spec version**: `Headless Component Spec v1` (link to `docs/SPEC_V1.md`).
- **Core versions**: versions of `headless_tokens`, `headless_foundation`, `headless_contracts`, `headless_theme` (and `headless_test`, if used).
- **Date**: date of last verification.
- **Test command**: command(s) used to run verification (e.g., `flutter test`, `dart test`, `melos test` - whatever is actually used in the package).
- **Conformance scope**: which parts of v1 contracts are applicable (e.g., `overlay: yes/no`, `listbox: yes/no`, `effects: yes/no`).
- **Evidence**: list of passed checks/test suites, at minimum:
  - Semantics/a11y
  - Keyboard-only
  - Controlled/uncontrolled
  - Overlay lifecycle (if overlay is applicable)

### 4.3 Recommended template (copy-paste)

```text
## Conformance Report

- Spec: Headless Component Spec v1 (see docs/SPEC_V1.md)
- Conformance: passes (see docs/CONFORMANCE.md)

- Core versions:
  - headless_tokens: X.Y.Z
  - headless_foundation: X.Y.Z
  - headless_contracts: X.Y.Z
  - headless_theme: X.Y.Z
  - headless_test: X.Y.Z (optional)

- Date: YYYY-MM-DD
- Test command(s):
  - <command 1>
  - <command 2>

- Scope:
  - overlay: yes/no
  - listbox: yes/no
  - effects: yes/no

- Evidence:
  - Semantics/a11y: PASS
  - Keyboard-only: PASS
  - Controlled/uncontrolled: PASS
  - Overlay lifecycle: PASS (n/a if overlay=no)
```
