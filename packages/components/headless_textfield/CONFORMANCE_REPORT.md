# Conformance Report

## Specification

- **Spec**: Headless Component Spec v1
- **Conformance**: [docs/CONFORMANCE.md](../../../docs/CONFORMANCE.md)

## Core Versions

- headless_tokens: 0.0.0
- headless_foundation: 0.0.0
- headless_theme: 0.0.0

## Date

2026-01-13

## Test Command

```bash
flutter test
```

## Scope

| Feature | Supported |
|---------|-----------|
| Overlay | No |
| Listbox | No |
| Effects | No |

## Evidence

### Semantics / A11y

| Check | Status | Test |
|-------|--------|------|
| TextField role | Pass | `textField role + enabled/disabled + readOnly` |

### Renderer Integration

| Check | Status | Test |
|-------|--------|------|
| Missing capability error | Covered elsewhere | `HeadlessThemeProvider` / `requireCapability` tests in `headless_theme` |

### Test Files

- `test/r_text_field_test.dart`
- `test/conformance_a11y_sla_test.dart`

