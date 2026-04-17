---
title: "dropdownRendererMustNotRequireThemeProviderConformance function"
description: "API documentation for the dropdownRendererMustNotRequireThemeProviderConformance function from dropdown_renderer_theme_provider_independence_conformance"
category: "Functions"
library: "dropdown_renderer_theme_provider_independence_conformance"
outline: false
---

# dropdownRendererMustNotRequireThemeProviderConformance

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">dropdownRendererMustNotRequireThemeProviderConformance</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">presetName</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">rendererGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">child</span>) <span class="param">wrapApp</span>,</span><span class="member-signature-line">});</span></div></div>

Conformance: preset renderers MUST NOT require [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider).

Presets are allowed to use:

- `HeadlessThemeProvider.of(context)` (nullable) for optional capabilities
but MUST NOT call:
- `HeadlessThemeProvider.themeOf(context)` inside renderer code paths

Rationale: conformance suites often render preset renderers in isolation.

