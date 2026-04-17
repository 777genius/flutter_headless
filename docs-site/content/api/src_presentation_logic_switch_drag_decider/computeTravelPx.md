---
title: "computeTravelPx function"
description: "API documentation for the computeTravelPx function from switch_drag_decider"
category: "Functions"
library: "switch_drag_decider"
outline: false
---

# computeTravelPx

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">double</span> <span class="fn">computeTravelPx</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">trackWidth</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">trackHeight</span>,</span><span class="member-signature-line">});</span></div></div>

Computes the thumb travel distance in pixels using Flutter's trackInnerLength formula.

`trackWidth` is the total track width.
`trackHeight` is the track height.

Returns the travel distance (trackInnerLength).

Flutter formula:

```dart
trackInnerStart = trackHeight / 2.0
trackInnerEnd = trackWidth - trackInnerStart
trackInnerLength = trackInnerEnd - trackInnerStart
```

For Material 3 (trackWidth=52, trackHeight=32):
trackInnerStart = 16.0
trackInnerEnd = 36.0
trackInnerLength = 20.0 px

