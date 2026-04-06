---
title: "mergeStyleIntoOverrides<TStyle, TOverride extends Object> function"
description: "API documentation for the mergeStyleIntoOverrides<TStyle, TOverride extends Object> function from style_merge"
category: "Functions"
library: "style_merge"
outline: false
---

# mergeStyleIntoOverrides\<TStyle, TOverride extends Object\>

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="fn">mergeStyleIntoOverrides&lt;TStyle, TOverride extends Object&gt;</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">TStyle</span>? <span class="param">style</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="param">overrides</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">TOverride</span> <span class="type">Function</span>(<span class="type">TStyle</span>) <span class="param">toOverride</span>,</span><span class="member-signature-line">});</span></div></div>

Merge a simple style object into [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) with POLA priority.

Priority (strong -> weak):

1. explicit `overrides`
2. `style` converted via `toOverride`

