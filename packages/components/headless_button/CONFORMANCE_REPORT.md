# Conformance Report

## Specification

- **Spec**: Headless Component Spec v1
- **Conformance**: [docs/CONFORMANCE.md](../../../docs/CONFORMANCE.md)

## Core Versions

- headless_tokens: 0.0.0
- headless_foundation: 0.0.0
- headless_theme: 0.0.0

## Date

2026-01-12

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
| Button role | Pass | `button has button semantic role` |
| Disabled state | Pass | `disabled button shows disabled state in semantics` |
| Semantic label | Pass | `semantic label is applied when provided` |

### Keyboard-only

| Check | Status | Test |
|-------|--------|------|
| Space activation | Pass | `Space triggers onPressed on key up` |
| Enter activation | Pass | `Enter triggers onPressed immediately` |
| Disabled ignores keys | Pass | `Space/Enter do not trigger when disabled` |
| No repeat on hold | Pass | `Space held does not repeat activation`, `Enter held does not repeat activation` |

### Controlled / Uncontrolled

| Check | Status | Test |
|-------|--------|------|
| onPressed null disables | Pass | `onPressed == null makes button disabled` |
| disabled prop overrides | Pass | `disabled == true makes button disabled even with onPressed` |
| State cleared on disable | Pass | `changing disabled clears pressed state` |
| Tap on disabled ignored | Pass | `tap on disabled button does not trigger onPressed` |

### Focus

| Check | Status | Test |
|-------|--------|------|
| Focus state tracked | Pass | `focus state is tracked` |
| Autofocus | Pass | `autofocus works` |
| Focus loss clears state | Pass | `focus loss clears pressed state` |

### Renderer Integration

| Check | Status | Test |
|-------|--------|------|
| Spec passed correctly | Pass | `spec is passed correctly to renderer` |
| Slots passed | Pass | `child is passed in slots` |
| Missing capability error | Pass | `throws MissingCapabilityException when renderer not available` |
| Missing theme error | Pass | `throws MissingThemeException when no theme provider` |

### Test Files

- `test/r_text_button_test.dart` (23 tests)
- `test/smoke_test.dart` (1 test)

**Total: 24 tests passing**
