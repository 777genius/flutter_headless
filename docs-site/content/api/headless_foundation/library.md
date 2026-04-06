---
title: "headless_foundation"
description: "API documentation for the headless_foundation library"
outline: [2, 3]
---

# headless_foundation

## Classes {#section-classes}

| Class | Description |
|---|---|
| [AsyncEffect\<T\>](/api/src_effects_effect/AsyncEffect) | Asynchronous effect (returns Future). |
| [Effect\<T\>](/api/src_effects_effect/Effect) | Base class for all effects. |
| [EffectCancelled\<T\>](/api/src_effects_effect_result/EffectCancelled) | Effect was cancelled before completion. |
| [EffectCategory](/api/src_effects_effect/EffectCategory) | Common effect categories. |
| [EffectExecutor](/api/src_effects_effect_executor/EffectExecutor) | Executor for running effects outside reducer. |
| [EffectFailed\<T\>](/api/src_effects_effect_result/EffectFailed) | Effect failed with error. |
| [EffectKey](/api/src_effects_effect_key/EffectKey) | Key for effect deduplication and cancellation. |
| [EffectResult\<T\>](/api/src_effects_effect_result/EffectResult) | Result of effect execution. |
| [EffectSucceeded\<T\>](/api/src_effects_effect_result/EffectSucceeded) | Effect completed successfully. |
| [HeadlessAlwaysFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessAlwaysFocusHighlightPolicy) | Always show focus highlight when a widget is focused. |
| [HeadlessContent](/api/src_listbox_headless_content/HeadlessContent) |  |
| [HeadlessEmojiContent](/api/src_listbox_headless_content/HeadlessEmojiContent) |  |
| [HeadlessFeatureKey\<T\>](/api/src_features_headless_feature_key/HeadlessFeatureKey) | Type-safe key for accessing typed features in feature bags. |
| [HeadlessFlutterFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFlutterFocusHighlightPolicy) | Flutter-like policy: show focus highlight only in keyboard navigation mode ("traditional"). |
| [HeadlessFocusHighlightController](/api/src_interaction_headless_focus_highlight_controller/HeadlessFocusHighlightController) | Shared controller that tracks `FocusManager.highlightMode` and converts it into a simple "show focus highlight" boolean via [HeadlessFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFocusHighlightPolicy). |
| [HeadlessFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessFocusHighlightPolicy) | Policy that decides when focus highlight (focus ring) should be visible. |
| [HeadlessFocusHighlightScope](/api/src_interaction_headless_focus_highlight_scope/HeadlessFocusHighlightScope) | Provides a [HeadlessFocusHighlightController](/api/src_interaction_headless_focus_highlight_controller/HeadlessFocusHighlightController) to descendants. |
| [HeadlessFocusHoverController](/api/src_interaction_headless_focus_hover_controller/HeadlessFocusHoverController) | Shared interaction controller for focus+hover (no press/activation). |
| [HeadlessFocusHoverState](/api/src_interaction_headless_focus_hover_state/HeadlessFocusHoverState) |  |
| [HeadlessFocusNodeOwner](/api/src_interaction_headless_focus_node_owner/HeadlessFocusNodeOwner) | Owns a `FocusNode` unless an external one is provided. |
| [HeadlessHoverRegion](/api/src_interaction_headless_hover_region/HeadlessHoverRegion) | Shared widget wrapper for hover handling. |
| [HeadlessIconContent](/api/src_listbox_headless_content/HeadlessIconContent) |  |
| [HeadlessItemAdapter\<T\>](/api/src_listbox_headless_item_adapter/HeadlessItemAdapter) |  |
| [HeadlessItemFeatures](/api/src_listbox_headless_item_features/HeadlessItemFeatures) |  |
| [HeadlessItemFeaturesBuilder](/api/src_listbox_headless_item_features/HeadlessItemFeaturesBuilder) | Builder for [HeadlessItemFeatures](/api/src_listbox_headless_item_features/HeadlessItemFeatures). |
| [HeadlessListItemModel](/api/src_listbox_headless_list_item_model/HeadlessListItemModel) |  |
| [HeadlessMenuAnchor](/api/src_menu_headless_menu_anchor/HeadlessMenuAnchor) | Value object for anchoring a menu overlay. |
| [HeadlessMenuOverlayController](/api/src_menu_headless_menu_overlay_controller/HeadlessMenuOverlayController) | Reusable controller for anchored menu overlays. |
| [HeadlessMenuState](/api/src_menu_headless_menu_state/HeadlessMenuState) | Minimal overlay state for anchored menus. |
| [HeadlessNeverFocusHighlightPolicy](/api/src_interaction_headless_focus_highlight_policy/HeadlessNeverFocusHighlightPolicy) | Never show focus highlight (even when focused). |
| [HeadlessPressableController](/api/src_interaction_headless_pressable_controller/HeadlessPressableController) | Shared interaction controller for "pressable" surfaces (buttons, dropdown triggers). |
| [HeadlessPressableRegion](/api/src_interaction_headless_pressable_region/HeadlessPressableRegion) | Shared widget wrapper for pressable surfaces. |
| [HeadlessPressableState](/api/src_interaction_headless_pressable_state/HeadlessPressableState) |  |
| [HeadlessPressableVisualEffectsController](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualEffectsController) | Controller that carries visual-only events to renderers. |
| [HeadlessPressableVisualEvent](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualEvent) | Visual-only events emitted by [HeadlessPressableRegion](/api/src_interaction_headless_pressable_region/HeadlessPressableRegion). |
| [HeadlessPressableVisualFocusChange](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualFocusChange) |  |
| [HeadlessPressableVisualHoverChange](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualHoverChange) |  |
| [HeadlessPressableVisualPointerCancel](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerCancel) |  |
| [HeadlessPressableVisualPointerDown](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerDown) |  |
| [HeadlessPressableVisualPointerUp](/api/src_interaction_headless_pressable_visual_effects/HeadlessPressableVisualPointerUp) |  |
| [HeadlessRequestFeatures](/api/src_features_headless_request_features/HeadlessRequestFeatures) | Immutable bag of typed features for render requests. |
| [HeadlessRequestFeaturesBuilder](/api/src_features_headless_request_features/HeadlessRequestFeaturesBuilder) | Builder for [HeadlessRequestFeatures](/api/src_features_headless_request_features/HeadlessRequestFeatures). |
| [HeadlessTextContent](/api/src_listbox_headless_content/HeadlessTextContent) |  |
| [HeadlessTextEditingControllerOwner](/api/src_interaction_headless_text_editing_controller_owner/HeadlessTextEditingControllerOwner) | Owns a `TextEditingController` unless an external one is provided. |
| [HeadlessTypeaheadLabel](/api/src_listbox_typeahead_label/HeadlessTypeaheadLabel) |  |
| [HeadlessWidgetStateMap\<T\>](/api/src_state_resolution_widget_state_map/HeadlessWidgetStateMap) | Map от [WidgetStateSet](/api/src_state_resolution_widget_state_set/WidgetStateSet) к значению с precedence-based lookup. |
| [ItemRegistry](/api/src_listbox_item_registry/ItemRegistry) |  |
| [JumpToFirst](/api/src_listbox_listbox_navigation_command/JumpToFirst) |  |
| [JumpToLast](/api/src_listbox_listbox_navigation_command/JumpToLast) |  |
| [ListboxController](/api/src_listbox_listbox_controller/ListboxController) | Foundation listbox controller (keyboard navigation + typeahead). |
| [ListboxItem](/api/src_listbox_listbox_item/ListboxItem) |  |
| [ListboxItemId](/api/src_listbox_listbox_item_id/ListboxItemId) | Stable identifier for listbox items. |
| [ListboxItemMeta](/api/src_listbox_listbox_item_meta/ListboxItemMeta) | Метаданные элемента listbox для навигации/тайпахеда. |
| [ListboxNavigation](/api/src_listbox_listbox_navigation_command/ListboxNavigation) | Абстрактные команды навигации listbox. |
| [ListboxNavigationPolicy](/api/src_listbox_listbox_navigation_policy/ListboxNavigationPolicy) |  |
| [ListboxScope](/api/src_listbox_listbox_scope/ListboxScope) |  |
| [ListboxState](/api/src_listbox_listbox_state/ListboxState) |  |
| [ListboxTypeaheadBuffer](/api/src_listbox_listbox_typeahead/ListboxTypeaheadBuffer) | Typeahead buffer with timeout. |
| [ListboxTypeaheadConfig](/api/src_listbox_listbox_typeahead/ListboxTypeaheadConfig) |  |
| [MoveHighlight](/api/src_listbox_listbox_navigation_command/MoveHighlight) | Переместить highlight на delta (+1 вниз, -1 вверх). |
| [OverlayHost](/api/src_overlay_overlay_host_compat/OverlayHost) | Backwards-compatible wrapper for [AnchoredOverlayEngineHost](/api/src_host_anchored_overlay_engine_host/AnchoredOverlayEngineHost). |
| [SelectHighlighted](/api/src_listbox_listbox_navigation_command/SelectHighlighted) |  |
| [StateResolutionPolicy](/api/src_state_resolution_state_resolution_policy/StateResolutionPolicy) | Политика нормализации конфликтующих состояний и генерации precedence. |
| [SyncEffect\<T\>](/api/src_effects_effect/SyncEffect) | Synchronous effect (completes immediately). |
| [TypeaheadChar](/api/src_listbox_listbox_navigation_command/TypeaheadChar) |  |
| [VoidEffect](/api/src_effects_effect/VoidEffect) | Effect that produces no result value (side-effect only). |
| [WcagConstants](/api/src_accessibility_wcag_constants/WcagConstants) | WCAG 2.1 accessibility constants. |
| [WidgetStateHelper](/api/src_state_widget_state_helper/WidgetStateHelper) | Helper for converting interaction states to Flutter's WidgetState set. |

## Exceptions {#section-exceptions}

| Exception |
|---|
| [StateResolutionError](/api/src_state_resolution_state_resolution_error/StateResolutionError) |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [HeadlessMenuFocusTransferPolicy](/api/src_menu_headless_menu_state/HeadlessMenuFocusTransferPolicy) | Focus transfer policy for anchored menu overlays. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [handlePressableKeyEvent](/api/src_interaction_headless_pressable_key_event_adapter/handlePressableKeyEvent) | Adapter: Flutter [KeyEvent](https://api.flutter.dev/flutter/dart-html/KeyEvent-class.html) -> pure [HeadlessPressableKeyIntent](/api/src_interaction_logic_headless_pressable_key_intent/HeadlessPressableKeyIntent). |

## Typedefs {#section-typedefs}

| Typedef | Description |
|---|---|
| [EffectResultCallback](/api/src_effects_effect_executor/EffectResultCallback) | Callback for receiving effect results. |
| ~~[HeadlessItemKey\<T\>](/api/src_listbox_headless_item_features/HeadlessItemKey)~~ | **Deprecated.** Backward-compatible alias for [HeadlessFeatureKey](/api/src_features_headless_feature_key/HeadlessFeatureKey). |
| [WidgetStateSet](/api/src_state_resolution_widget_state_set/WidgetStateSet) | Alias для совместимости API и читаемости. |

