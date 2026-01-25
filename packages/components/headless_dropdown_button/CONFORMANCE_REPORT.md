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
| Overlay | Yes |
| Listbox | Yes |
| Effects | No |

## Evidence

### Semantics / A11y

| Check | Status | Test |
|-------|--------|------|
| Button role | Pass | `dropdown has button semantic role` |
| Expanded state | Pass | `expanded state is reflected when menu opens` |
| Disabled state | Pass | `disabled dropdown shows disabled state in semantics` |
| Semantic label | Pass | `semantic label is applied when provided` |

### Keyboard-only

| Check | Status | Test |
|-------|--------|------|
| Open: Space | Pass | `Space opens menu on key up` |
| Open: Enter | Pass | `Enter opens menu immediately` |
| Open: ArrowDown | Pass | `ArrowDown opens menu` |
| Navigate: ArrowDown | Pass | `ArrowDown navigates through items` |
| Navigate: ArrowUp | Pass | `ArrowUp navigates backwards` |
| Navigate: Home/End | Pass | `Home/End jumps to first/last item` |
| Select: Enter | Pass | `Enter selects highlighted item and closes` |
| Close: Escape | Pass | `Escape closes without changing selection` |
| Wrap-around | Pass | `ArrowDown on last item wraps to first enabled` |
| Skip disabled | Pass | `disabled items are skipped during navigation` |

### Overlay Lifecycle

| Check | Status | Test |
|-------|--------|------|
| Phases | Pass | `close() transitions to closing phase`, `completeClose() transitions to closed phase` |
| Focus restore | Pass | `focus returns to trigger after close` |

### Invariants

| Invariant | Status | Notes |
|-----------|--------|-------|
| highlighted != selected | Pass | Navigation changes highlight, Enter commits to selection |
| disabled items not selectable | Pass | Disabled items skipped in navigation and selection |
| wrap-around enabled | Pass | ArrowDown/Up wrap at boundaries |
| focus restore on close | Pass | Focus returns to trigger |
| close contract | Pass | `close()` -> closing, `completeClose()` -> closed |
| selected disabled fallback | Pass | If selected item is disabled, highlights first enabled instead |

### Renderer Contract (v1 policy)

| Check | Status | Notes |
|-------|--------|-------|
| Non-generic renderer | Pass | `RDropdownButtonRenderer` has no `<T>` |
| Non-generic resolver | Pass | `RDropdownTokenResolver` has no `<T>` |
| Items UI-only | Pass | `RDropdownItem` has no value field |
| State uses indices | Pass | `selectedIndex`/`highlightedIndex`, not `selectedValue` |
| Callbacks use indices | Pass | `onSelectIndex(int)`, not `onSelect(T)` |
| Value↔index mapping | Pass | Component maps `RDropdownEntry<T>` → `RDropdownItem` |
| Simple capability lookup | Pass | `capability<RDropdownButtonRenderer>()` — no workarounds |

### Test Files

- `test/r_dropdown_button_test.dart` (30 tests)
- `test/smoke_test.dart` (1 test)

**Total: 31 tests passing**
