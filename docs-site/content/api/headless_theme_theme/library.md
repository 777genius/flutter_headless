---
title: "theme"
description: "API documentation for the theme library"
outline: [2, 3]
---

# theme

## Classes {#section-classes}

| Class | Description |
|---|---|
| [CapabilityOverrides](/api/src_theme_capability_overrides/CapabilityOverrides) | Type-safe override bag for theme capabilities. |
| [CapabilityOverridesBuilder](/api/src_theme_capability_overrides/CapabilityOverridesBuilder) | Builder for [CapabilityOverrides](/api/src_theme_capability_overrides/CapabilityOverrides). |
| [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) | Root capability discovery contract (v1 skeleton). |
| [HeadlessThemeOverridesScope](/api/src_theme_headless_theme_overrides_scope/HeadlessThemeOverridesScope) | Scoped capability overrides for a subtree. |
| [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) | Provides [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) to descendant widgets. |
| [HeadlessThemeWithOverrides](/api/src_theme_headless_theme_with_overrides/HeadlessThemeWithOverrides) | Headless theme wrapper that overrides specific capabilities. |

## Exceptions {#section-exceptions}

| Exception | Description |
|---|---|
| [MissingCapabilityException](/api/src_theme_require_capability/MissingCapabilityException) | Exception thrown when a required capability is missing from the theme. |
| [MissingThemeException](/api/src_theme_headless_theme_provider/MissingThemeException) | Exception thrown when [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) is not found in the widget tree. |

## Functions {#section-functions}

| Function | Description |
|---|---|
| [requireCapability\<T\>](/api/src_theme_require_capability/requireCapability) | Require a capability from the theme, throwing a standardized error if missing. |

