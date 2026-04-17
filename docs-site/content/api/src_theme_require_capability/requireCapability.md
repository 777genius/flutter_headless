---
title: "requireCapability<T> function"
description: "API documentation for the requireCapability<T> function from require_capability"
category: "Functions"
library: "require_capability"
outline: false
---

# requireCapability\<T\>

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">T</span> <span class="fn">requireCapability&lt;T&gt;</span>(</span><span class="member-signature-line">  <a href="/api/src_theme_headless_theme/HeadlessTheme" class="type-link">HeadlessTheme</a> <span class="param">theme</span>, {</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">componentName</span>,</span><span class="member-signature-line">});</span></div></div>

Require a capability from the theme, throwing a standardized error if missing.

This is the central guard for capability discovery.
Components should use this instead of checking [HeadlessTheme.capability](/api/src_theme_headless_theme/HeadlessTheme#capability)
directly when the capability is required.

Example:

```dart
final renderer = requireCapability<RButtonRenderer>(
  theme,
  componentName: 'RTextButton',
);
```

Throws [MissingCapabilityException](/api/src_theme_require_capability/MissingCapabilityException) if the capability is not available.

