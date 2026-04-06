---
title: "switch_drag_decider"
description: "API documentation for the switch_drag_decider library"
outline: [2, 3]
---

# switch_drag_decider

## Functions {#section-functions}

| Function | Description |
|---|---|
| [computeDragVisualValue](/api/src_presentation_logic_switch_drag_decider/computeDragVisualValue) | Computes the preview visual value during drag. |
| [computeNextValue](/api/src_presentation_logic_switch_drag_decider/computeNextValue) | Computes the next switch value based on drag position and velocity. |
| [computeTravelPx](/api/src_presentation_logic_switch_drag_decider/computeTravelPx) | Computes the thumb travel distance in pixels using Flutter's trackInnerLength formula. |
| [initialDragT](/api/src_presentation_logic_switch_drag_decider/initialDragT) | Computes the initial drag T from the current switch value. |
| [updateDragT](/api/src_presentation_logic_switch_drag_decider/updateDragT) | Updates the drag position based on horizontal drag delta. |

## Constants {#section-constants}

| Constant | Description |
|---|---|
| [kSwitchFlingVelocityThreshold](/api/src_presentation_logic_switch_drag_decider/kSwitchFlingVelocityThreshold) | Velocity threshold for fling-to-toggle behavior (px/sec). |
| [kSwitchPositionThreshold](/api/src_presentation_logic_switch_drag_decider/kSwitchPositionThreshold) | Position threshold for toggle decision when no fling detected. |

