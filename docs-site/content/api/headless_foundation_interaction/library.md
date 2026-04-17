---
title: "interaction"
description: "API documentation for the interaction library"
outline: [2, 3]
---

# interaction

## Classes {#section-classes}

| Class | Description |
|---|---|
| [HeadlessAlwaysFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessAlwaysFocusHighlightPolicy) | Always show focus highlight when a widget is focused. |
| [HeadlessFlutterFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFlutterFocusHighlightPolicy) | Flutter-like policy: show focus highlight only in keyboard navigation mode ("traditional"). |
| [HeadlessFocusHighlightController](/api/src_interaction_headless_focus_highlight_controller/HeadlessFocusHighlightController) | Shared controller that tracks `FocusManager.highlightMode` and converts it into a simple "show focus highlight" boolean via [HeadlessFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFocusHighlightPolicy). |
| [HeadlessFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFocusHighlightPolicy) | Policy that decides when focus highlight (focus ring) should be visible. |
| [HeadlessFocusHighlightScope](/api/src_interaction_headless_focus_highlight_scope/HeadlessFocusHighlightScope) | Provides a [HeadlessFocusHighlightController](/api/src_interaction_headless_focus_highlight_controller/HeadlessFocusHighlightController) to descendants. |
| [HeadlessFocusHoverController](/api/src_interaction_headless_focus_hover_controller/HeadlessFocusHoverController) | Shared interaction controller for focus+hover (no press/activation). |
| [HeadlessFocusHoverState](/api/src_interaction_headless_focus_hover_state/HeadlessFocusHoverState) | No description available in source docs. |
| [HeadlessFocusNodeOwner](/api/src_interaction_headless_focus_node_owner/HeadlessFocusNodeOwner) | Owns a `FocusNode` unless an external one is provided. |
| [HeadlessHoverRegion](/api/src_interaction_headless_hover_region/HeadlessHoverRegion) | Shared widget wrapper for hover handling. |
| [HeadlessNeverFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessNeverFocusHighlightPolicy) | Never show focus highlight (even when focused). |
| [HeadlessPressableController](/api/src_interaction_headless_pressable_controller/HeadlessPressableController) | Shared interaction controller for "pressable" surfaces (buttons, dropdown triggers). |
| [HeadlessPressableRegion](/api/src_interaction_headless_pressable_region/HeadlessPressableRegion) | Shared widget wrapper for pressable surfaces. |
| [HeadlessPressableState](/api/src_interaction_headless_pressable_state/HeadlessPressableState) | No description available in source docs. |
| [HeadlessPressableVisualEffectsController](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualEffectsController) | Controller that carries visual-only events to renderers. |
| [HeadlessPressableVisualEvent](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualEvent) | Visual-only events emitted by [HeadlessPressableRegion](/api/src_interaction_headless_pressable_region/HeadlessPressableRegion). |
| [HeadlessPressableVisualFocusChange](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualFocusChange) | No description available in source docs. |
| [HeadlessPressableVisualHoverChange](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualHoverChange) | No description available in source docs. |
| [HeadlessPressableVisualPointerCancel](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerCancel) | No description available in source docs. |
| [HeadlessPressableVisualPointerDown](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerDown) | No description available in source docs. |
| [HeadlessPressableVisualPointerUp](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerUp) | No description available in source docs. |
| [HeadlessTextEditingControllerOwner](/api/src_interaction_headless_text_editing_controller_owner/HeadlessTextEditingControllerOwner) | Owns a `TextEditingController` unless an external one is provided. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [handlePressableKeyEvent](/api/src_interaction_headless_pressable_key_event_adapter/handlePressableKeyEvent) | Adapter: Flutter [KeyEvent](https://api.flutter.dev/flutter/dart-html/KeyEvent-class.html) -> pure [HeadlessPressableKeyIntent](/api/src_interaction_logic_headless_pressable_key_intent/HeadlessPressableKeyIntent). |

