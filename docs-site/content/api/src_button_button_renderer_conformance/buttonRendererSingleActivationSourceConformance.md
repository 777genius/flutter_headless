---
title: "buttonRendererSingleActivationSourceConformance function"
description: "API documentation for the buttonRendererSingleActivationSourceConformance function from button_renderer_conformance"
category: "Functions"
library: "button_renderer_conformance"
outline: false
---

# buttonRendererSingleActivationSourceConformance

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">buttonRendererSingleActivationSourceConformance</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">presetName</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">rendererGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">child</span>) <span class="param">wrapApp</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">createDefaultTokens</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">void</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">tester</span>) <span class="param">assertSingleActivationSource</span>,</span><span class="member-signature-line">});</span></div></div>

Conformance suite for button renderers (presets).

Focus: enforce the v1 invariant "single activation source".
Renderers must not attach tap handlers that would bypass/double-trigger
component-level activation.

