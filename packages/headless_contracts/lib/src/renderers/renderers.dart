/// Renderer contracts for Headless components.
///
/// These are capability contracts (ISP): components request renderers
/// via [HeadlessTheme.capability<T>()].
///
/// Renderers implement these contracts to provide visual representation.
/// Components never know the concrete renderer implementation.
library;

// Core
export 'render_overrides.dart';
export 'renderer_policy.dart';
export 'style_merge.dart';

// Button
export 'button/button.dart';

// Dropdown
export 'dropdown/dropdown.dart';

// TextField
export 'textfield/textfield.dart';

// Autocomplete
export 'autocomplete/autocomplete.dart';

// Checkbox
export 'checkbox/checkbox.dart';

// CheckboxListTile
export 'checkbox_list_tile/checkbox_list_tile.dart';

// Switch
export 'switch/switch.dart';

// SwitchListTile
export 'switch_list_tile/switch_list_tile.dart';
