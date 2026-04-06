---
title: "kSwitchFlingVelocityThreshold constant"
description: "API documentation for the kSwitchFlingVelocityThreshold constant from switch_drag_decider"
category: "Constants"
library: "switch_drag_decider"
outline: false
---

# kSwitchFlingVelocityThreshold

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="type">double</span> <span class="fn">kSwitchFlingVelocityThreshold</span></div></div>

Velocity threshold for fling-to-toggle behavior (px/sec).

If the fling velocity exceeds this threshold, the switch will toggle
regardless of the current drag position.

This matches Flutter's actual Switch implementation (300.0 px/s).

