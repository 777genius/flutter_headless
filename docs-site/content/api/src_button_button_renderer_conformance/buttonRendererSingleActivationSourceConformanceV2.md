---
title: "buttonRendererSingleActivationSourceConformanceV2 function"
description: "API documentation for the buttonRendererSingleActivationSourceConformanceV2 function from button_renderer_conformance"
category: "Functions"
library: "button_renderer_conformance"
outline: false
---

# buttonRendererSingleActivationSourceConformanceV2

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">buttonRendererSingleActivationSourceConformanceV2</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">presetName</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">rendererGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">child</span>) <span class="param">wrapApp</span>,</span><span class="member-signature-line">});</span></div></div>

V2 conformance suite for parity renderers.

Parity renderers may use Flutter buttons internally (which have their own
GestureDetectors). The invariant is satisfied if the renderer wraps its
output in an inert guard: `ExcludeSemantics` + `AbsorbPointer(absorbing: true)`.

Alternatively, a renderer may still satisfy the invariant by having *no*
interactive handlers in its subtree (pure visual tree).

