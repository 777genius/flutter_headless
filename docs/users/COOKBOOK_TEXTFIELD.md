# TextField Cookbook

## Overview

Headless provides a renderless `RTextField` component that works with any visual theme. The component handles all text input logic (controlled/controller modes, focus, validation, accessibility) while the theme provides the visual rendering.

## Quick Start

### Basic Usage (Theme-Agnostic)

```dart
import 'package:headless_textfield/headless_textfield.dart';

// Controlled mode (React-style)
RTextField(
  value: _email,
  onChanged: (v) => setState(() => _email = v),
  placeholder: 'Enter your email',
)

// Controller-driven mode
RTextField(
  controller: _controller,
  placeholder: 'Enter text...',
)
```

### Cupertino (iOS) Style

```dart
import 'package:headless_cupertino/headless_cupertino.dart';

RCupertinoTextField(
  value: _text,
  onChanged: (v) => setState(() => _text = v),
  placeholder: 'Enter text...',
)
```

## Cupertino TextField Features

### Clear Button

The clear button appears when the field has text. Control visibility with `clearButtonMode`:

```dart
// Show while editing (default for RCupertinoTextField)
RCupertinoTextField(
  value: _text,
  onChanged: (v) => setState(() => _text = v),
  placeholder: 'Type something...',
  clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
)

// Always show when there's text
RCupertinoTextField(
  clearButtonMode: RTextFieldOverlayVisibilityMode.always,
  ...
)

// Never show
RCupertinoTextField(
  clearButtonMode: RTextFieldOverlayVisibilityMode.never,
  ...
)

// Show when not editing
RCupertinoTextField(
  clearButtonMode: RTextFieldOverlayVisibilityMode.notEditing,
  ...
)
```

### Prefix and Suffix

Add icons or widgets inside the text field:

```dart
RCupertinoTextField(
  value: _search,
  onChanged: (v) => setState(() => _search = v),
  placeholder: 'Search...',
  prefix: Padding(
    padding: EdgeInsets.only(left: 6),
    child: Icon(CupertinoIcons.search, size: 18),
  ),
  suffix: Padding(
    padding: EdgeInsets.only(right: 6),
    child: Icon(CupertinoIcons.mic, size: 18),
  ),
  clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
)
```

Control prefix/suffix visibility:

```dart
RCupertinoTextField(
  prefix: Icon(CupertinoIcons.search),
  prefixMode: RTextFieldOverlayVisibilityMode.always, // default
  suffix: Icon(CupertinoIcons.mic),
  suffixMode: RTextFieldOverlayVisibilityMode.whileEditing,
  ...
)
```

### Borderless Mode

For fields that blend with their background:

```dart
Container(
  color: CupertinoColors.systemGrey5,
  padding: EdgeInsets.all(8),
  child: RCupertinoTextField(
    value: _text,
    onChanged: (v) => setState(() => _text = v),
    placeholder: 'Borderless input...',
    isBorderless: true,
  ),
)
```

### Custom Padding

Override the default iOS 7px padding:

```dart
RCupertinoTextField(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ...
)
```

## Migration from CupertinoTextField

### Before (Flutter native)

```dart
CupertinoTextField(
  controller: _controller,
  placeholder: 'Enter text',
  prefix: Icon(CupertinoIcons.search),
  suffix: Icon(CupertinoIcons.mic),
  clearButtonMode: OverlayVisibilityMode.whileEditing,
  decoration: BoxDecoration(
    border: Border.all(color: CupertinoColors.systemGrey4),
    borderRadius: BorderRadius.circular(5),
  ),
)
```

### After (Headless)

```dart
RCupertinoTextField(
  controller: _controller,
  placeholder: 'Enter text',
  prefix: Icon(CupertinoIcons.search),
  suffix: Icon(CupertinoIcons.mic),
  clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
  // Decoration comes from theme, or use overrides:
  overrides: RenderOverrides.only(
    RTextFieldOverrides.tokens(
      containerBorderColor: CupertinoColors.systemGrey4,
      containerBorderRadius: BorderRadius.circular(5),
    ),
  ),
)
```

## Common Patterns

### Search Field

```dart
RCupertinoTextField(
  value: _query,
  onChanged: (v) => setState(() => _query = v),
  placeholder: 'Search...',
  prefix: Padding(
    padding: EdgeInsets.only(left: 8),
    child: Icon(CupertinoIcons.search, size: 18),
  ),
  clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
  textInputAction: TextInputAction.search,
  onSubmitted: (query) => _performSearch(query),
)
```

### Password Field

```dart
RCupertinoTextField(
  value: _password,
  onChanged: (v) => setState(() => _password = v),
  placeholder: 'Enter password',
  obscureText: true,
  textInputAction: TextInputAction.done,
)
```

### Email Field with Validation

```dart
RCupertinoTextField(
  value: _email,
  onChanged: (v) => setState(() => _email = v),
  placeholder: 'Enter email',
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  autocorrect: false,
  errorText: _isEmailValid(_email) ? null : 'Invalid email',
)
```

### Multiline Input

```dart
RCupertinoTextField(
  value: _description,
  onChanged: (v) => setState(() => _description = v),
  placeholder: 'Enter description...',
  maxLines: 4,
  minLines: 2,
  maxLength: 500,
)
```

## Styling and Overrides

### Per-Instance Token Overrides

```dart
RCupertinoTextField(
  overrides: RenderOverrides.only(
    RTextFieldOverrides.tokens(
      containerBorderColor: CupertinoColors.activeBlue,
      containerBorderRadius: BorderRadius.circular(12),
      containerBorderWidth: 2,
    ),
  ),
  ...
)
```

### Using RTextFieldStyle

```dart
RCupertinoTextField(
  style: RTextFieldStyle(
    containerBorderColor: Colors.blue,
    textStyle: TextStyle(fontSize: 16),
  ),
  ...
)
```

## API Reference

### RCupertinoTextField Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `String?` | - | Current text value (controlled mode) |
| `controller` | `TextEditingController?` | - | Controller (controller mode) |
| `onChanged` | `ValueChanged<String>?` | - | Called when text changes |
| `placeholder` | `String?` | - | Placeholder text |
| `prefix` | `Widget?` | - | Widget before text |
| `suffix` | `Widget?` | - | Widget after text |
| `clearButtonMode` | `RTextFieldOverlayVisibilityMode` | `whileEditing` | Clear button visibility |
| `prefixMode` | `RTextFieldOverlayVisibilityMode` | `always` | Prefix visibility |
| `suffixMode` | `RTextFieldOverlayVisibilityMode` | `always` | Suffix visibility |
| `padding` | `EdgeInsetsGeometry?` | - | Custom padding (default: 7px) |
| `isBorderless` | `bool` | `false` | Remove border |
| `enabled` | `bool` | `true` | Enable/disable field |
| `readOnly` | `bool` | `false` | Make read-only |
| `obscureText` | `bool` | `false` | Hide text (password) |
| `maxLines` | `int?` | `1` | Max lines |
| `minLines` | `int?` | - | Min lines |
| `maxLength` | `int?` | - | Max characters |

### RTextFieldOverlayVisibilityMode

| Value | Description |
|-------|-------------|
| `never` | Never show |
| `whileEditing` | Show when focused and has text |
| `notEditing` | Show when not focused and has text |
| `always` | Always show when has text |
