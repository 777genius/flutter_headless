---
sidebar_position: 8
sidebar_label: “Changelog”
---

# Documentation Changelog

This log tracks notable changes to the documentation (not the code itself).

## [Unreleased]

### 2026-01-17 — DX docs sync (HIGH)

- Synchronized entrypoints and DX formulas:
  - `README.md`, `docs/en/README.md` — added `style:`/priority/defaults/scopes.
  - `docs/users/README.md` — unified wording for `style:` and priorities.
- Updated internal RU docs:
  - `docs/ru/README.md`, `docs/ru/README_INTERNAL.md`, `docs/WHY_HEADLESS.md`.
- Unified wording in README/LLM files of component packages:
  - `headless_button`, `headless_dropdown_button`, `headless_textfield`,
    `headless_checkbox`, `headless_autocomplete`.

### 2026-01-11 — Spec-first documentation layer (CRITICAL)

- Added normative documents for the ecosystem:
  - `docs/SPEC_V1.md` — Headless Component Spec v1 (MUST/SHOULD/MAY).
  - `docs/CONFORMANCE.md` — how to claim Headless compatibility + minimal checklist/tests.
- Strengthened architectural constraints (“this is the only way we do it”):
  - `docs/ARCHITECTURE.md` — Spec-first section + Definition of Done for a Headless-compatible package + updated `docs/` tree.
- Updated cross-references:
  - `README.md` — spec-first positioning + links to SPEC/CONFORMANCE.
  - `docs/V1_DECISIONS.md` — added link to `docs/CONFORMANCE.md`.

---

## Format

Each entry includes:
- **Date**
- **Category** (CRITICAL/HIGH/MEDIUM/LOW)
- **Brief description**
- **List of affected files**
