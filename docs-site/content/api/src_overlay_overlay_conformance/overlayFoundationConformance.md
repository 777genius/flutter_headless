---
title: "overlayFoundationConformance function"
description: "API documentation for the overlayFoundationConformance function from overlay_conformance"
category: "Functions"
library: "overlay_conformance"
outline: false
---

# overlayFoundationConformance

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">overlayFoundationConformance</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">suiteName</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">child</span>) <span class="param">wrapApp</span>,</span><span class="member-signature-line">});</span></div></div>

Conformance suite for `anchored_overlay_engine` primitives.

Goal: make the overlay lifecycle + policies verifiable and stable.

This suite is intentionally small and focused on MUST behaviors:

- lifecycle phases & fail-safe close (no "stuck closing")
- dismiss policies (outside tap / escape / focus loss)
- focus policies (initialFocus + restoreOnClose)

