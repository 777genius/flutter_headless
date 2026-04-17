---
title: "mergeOverridesWithFallbacks function"
description: "API documentation for the mergeOverridesWithFallbacks function from style_merge"
category: "Functions"
library: "style_merge"
outline: false
---

# mergeOverridesWithFallbacks

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="fn">mergeOverridesWithFallbacks</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="param">base</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>?&gt; <span class="param">fallbacks</span>,</span><span class="member-signature-line">});</span></div></div>

Merge multiple sugar layers into overrides with POLA priority.

Priority (strong -> weak):

1. `base` — explicit overrides, always win
2. `fallbacks` — sugar layers in order (later = stronger)

Example for RSwitch with thumbIcon + style sugar:

```dart
mergeOverridesWithFallbacks(
  base: widget.overrides,
  fallbacks: [
    // style is weakest sugar
    if (widget.style != null)
      RenderOverrides.only(widget.style!.toOverrides()),
    // thumbIcon is stronger than style, but weaker than overrides
    if (widget.thumbIcon != null)
      RenderOverrides.only(RSwitchOverrides.tokens(thumbIcon: widget.thumbIcon)),
  ],
);
```

