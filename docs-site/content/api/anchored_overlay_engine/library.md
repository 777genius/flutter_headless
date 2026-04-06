---
title: "anchored_overlay_engine"
description: "API documentation for the anchored_overlay_engine library"
outline: [2, 3]
---

# anchored_overlay_engine

## Classes {#section-classes}

| Class | Description |
|---|---|
| [AnchoredOverlayEngineHost](/api/src_host_anchored_overlay_engine_host/AnchoredOverlayEngineHost) | A widget that hosts anchored overlay layers. |
| [AnchoredOverlayLayout](/api/src_positioning_anchored_overlay_layout/AnchoredOverlayLayout) |  |
| [AnchoredOverlayLayoutCalculator](/api/src_positioning_anchored_overlay_layout/AnchoredOverlayLayoutCalculator) | Computes anchored overlay layout using a small collision pipeline: |
| [CloseContractRunner](/api/src_lifecycle_close_contract_runner/CloseContractRunner) | A small helper to implement the overlay close contract safely. |
| [CloseOverlayIntent](/api/src_host_anchored_overlay_engine_host/CloseOverlayIntent) | Intent to close the topmost overlay. |
| [DismissByTriggers](/api/src_policies_overlay_dismiss_policy/DismissByTriggers) |  |
| [DismissPolicy](/api/src_policies_overlay_dismiss_policy/DismissPolicy) | Политика закрытия overlay через внешние триггеры. |
| [FocusPolicy](/api/src_policies_overlay_focus_policy/FocusPolicy) | Политика управления фокусом для overlay. |
| [ModalFocusPolicy](/api/src_policies_overlay_focus_policy/ModalFocusPolicy) | Modal overlay: по умолчанию предполагает trap + restore. |
| [NonModalFocusPolicy](/api/src_policies_overlay_focus_policy/NonModalFocusPolicy) | Non-modal overlay: фокус остаётся свободным. |
| [OverlayAnchor](/api/src_model_overlay_anchor/OverlayAnchor) |  |
| [OverlayBarrierPolicy](/api/src_policies_overlay_barrier_policy/OverlayBarrierPolicy) |  |
| [OverlayController](/api/src_controller_overlay_controller/OverlayController) | Controller for managing overlay layers. |
| [OverlayHandle](/api/src_lifecycle_overlay_handle/OverlayHandle) | Minimal overlay handle contract. |
| [OverlayInsertionBackend](/api/src_insertion_overlay_insertion_backend/OverlayInsertionBackend) |  |
| [OverlayInsertionHandle](/api/src_insertion_overlay_insertion_backend/OverlayInsertionHandle) |  |
| [OverlayPortalInsertionBackend](/api/src_insertion_overlay_portal_insertion_backend/OverlayPortalInsertionBackend) |  |
| [OverlayRepositionPolicy](/api/src_policies_overlay_reposition_policy/OverlayRepositionPolicy) |  |
| [OverlayRequest](/api/src_model_overlay_request/OverlayRequest) |  |

## Exceptions {#section-exceptions}

| Exception | Description |
|---|---|
| [MissingOverlayHostException](/api/src_host_missing_overlay_host_exception/MissingOverlayHostException) | Exception thrown when an [AnchoredOverlayEngineHost](/api/src_host_anchored_overlay_engine_host/AnchoredOverlayEngineHost) is required but not found. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [AnchoredOverlayPlacement](/api/src_positioning_anchored_overlay_layout/AnchoredOverlayPlacement) | Vertical placement of an anchored overlay relative to its anchor. |
| [DismissTrigger](/api/src_policies_overlay_dismiss_policy/DismissTrigger) | Триггеры закрытия overlay. |
| [OverlayPhase](/api/src_lifecycle_overlay_phase/OverlayPhase) |  |
| [OverlayStackPolicy](/api/src_policies_overlay_stack_policy/OverlayStackPolicy) |  |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [computeOverlayViewportRect](/api/src_positioning_anchored_overlay_layout/computeOverlayViewportRect) | Computes the effective viewport rect for overlay collision. |

## Constants {#section-constants}

| Constant | Description |
|---|---|
| [kOverlayFailSafeTimeout](/api/anchored_overlay_engine/kOverlayFailSafeTimeout) | Default fail-safe timeout duration for closing phase. |

## Typedefs {#section-typedefs}

| Typedef | Description |
|---|---|
| [OverlayTimeoutCallback](/api/src_lifecycle_overlay_handle/OverlayTimeoutCallback) | Callback for fail-safe timeout diagnostic. |

