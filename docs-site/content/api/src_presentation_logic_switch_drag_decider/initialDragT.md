---
title: "initialDragT function"
description: "API documentation for the initialDragT function from switch_drag_decider"
category: "Functions"
library: "switch_drag_decider"
outline: false
---

# initialDragT

<div class="member-signature"><div class="member-signature-code"><span class="type">double</span> <span class="fn">initialDragT</span>({<span class="kw">required</span> <span class="type">bool</span> <span class="param">value</span>, <span class="kw">required</span> <span class="type">bool</span> <span class="param">isRtl</span>})</div></div>

Computes the initial drag T from the current switch value.

`value` is the current switch value (true = on).
`isRtl` indicates right-to-left layout direction (affects position).

Returns the initial 0..1 thumb position.

