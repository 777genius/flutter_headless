# Conformance Report

## Specification

- **Spec**: Headless Component Spec v1
- **Conformance**: [docs/CONFORMANCE.md](../../../docs/CONFORMANCE.md)

## Core Versions

- headless_tokens: 0.0.0
- headless_foundation: 0.0.0
- headless_theme: 0.0.0

## Date

2026-01-17

## Test Command

```bash
flutter test
```

## Scope

| Feature | Supported |
|---------|-----------|
| Overlay | Yes |
| Listbox | Yes (highlight/navigation/disabled) |
| Effects | No |

## Evidence

### Semantics / A11y

| Check | Status | Test |
|-------|--------|------|
| TextField role | Pass | `textField role + enabled/disabled + readOnly` |
| Expanded state | Pass | `expanded state is reflected when menu opens` |

### Keyboard-only

| Check | Status | Test |
|-------|--------|------|
| Open/Navigate: ArrowDown | Pass | `ArrowDown opens menu and navigates highlight` |
| Close: Escape | Covered by coordinator | (added in v1.6 SLA tests) |

### Selection / Text Sync

| Check | Status | Test |
|-------|--------|------|
| Selecting option updates controller text | Pass | `selecting option updates text and selection` |
| User edit clears selection | Pass | `user edit clears selection state` |

### Open triggers

| Check | Status | Test |
|-------|--------|------|
| openOnTap behavior | Pass | `openOnTap opens menu when already focused` |
| local source perf contract | Pass | `optionsBuilder runs only on text changes` |

### Style sugar → overrides mapping (POLA)

| Check | Status | Test |
|-------|--------|------|
| Field style maps into overrides | Pass | `field style maps into text field overrides` |
| Options style maps into overrides | Pass | `options style maps into menu overrides` |
| Explicit overrides win over style | Pass | `explicit overrides win over style` |

### Test Files

- `test/r_autocomplete_test.dart`
- `test/conformance_a11y_sla_test.dart`
