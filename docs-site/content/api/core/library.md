---
title: "core"
description: "API documentation for the core library"
outline: [2, 3]
---

# core

Core contracts: RenderOverrides, RendererPolicy, StyleMerge.

## Classes {#section-classes}

| Class | Description |
|---|---|
| [HeadlessRendererPolicy](/api/src_renderers_renderer_policy/HeadlessRendererPolicy) | Optional renderer policy for stricter contracts in debug/test. |
| [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) | Per-instance override bag for renderers and token resolvers. |
| [RenderOverridesDebugTracker](/api/src_renderers_render_overrides/RenderOverridesDebugTracker) | Debug-only tracker for consumed override types. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [mergeOverridesWithFallbacks](/api/src_renderers_style_merge/mergeOverridesWithFallbacks) | Merge multiple sugar layers into overrides with POLA priority. |
| [mergeStyleIntoOverrides\<TStyle, TOverride extends Object\>](/api/src_renderers_style_merge/mergeStyleIntoOverrides) | Merge a simple style object into [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) with POLA priority. |

