---
title: "updateDragT function"
description: "API documentation for the updateDragT function from switch_drag_decider"
category: "Functions"
library: "switch_drag_decider"
outline: false
---

# updateDragT

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">double</span> <span class="fn">updateDragT</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">currentT</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">deltaX</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">travelPx</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isRtl</span>,</span><span class="member-signature-line">});</span></div></div>

Updates the drag position based on horizontal drag delta.

`currentT` is the current 0..1 thumb position.
`deltaX` is the horizontal drag delta in pixels.
`travelPx` is the total travel distance in pixels (trackInnerLength).
`isRtl` indicates right-to-left layout direction.

Returns the new 0..1 thumb position, clamped to `0, 1`.

