---
title: "computeNextValue function"
description: "API documentation for the computeNextValue function from switch_drag_decider"
category: "Functions"
library: "switch_drag_decider"
outline: false
---

# computeNextValue

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">bool</span> <span class="fn">computeNextValue</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">dragT</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">velocity</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isRtl</span>,</span><span class="member-signature-line">});</span></div></div>

Computes the next switch value based on drag position and velocity.

`dragT` is the current 0..1 thumb position.
`velocity` is the horizontal fling velocity in px/sec (positive = right).
`isRtl` indicates right-to-left layout direction.

Returns the new switch value (true = on, false = off).

Logic (matches Flutter Switch):

1. If velocity exceeds threshold → toggle based on velocity direction
2. Otherwise → toggle based on position (>= 0.5 = on)

