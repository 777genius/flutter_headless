---
title: "rAutocompleteItemSourceKey constant"
description: "API documentation for the rAutocompleteItemSourceKey constant from headless_autocomplete"
category: "Constants"
library: "headless_autocomplete"
outline: false
---

# rAutocompleteItemSourceKey

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="type">dynamic</span> <span class="fn">rAutocompleteItemSourceKey</span></div></div>

Feature key for item source in item features.

Use this key to read item source in renderers:

```dart
final source = item.features.get(rAutocompleteItemSourceKey);
if (source == RAutocompleteItemSource.remote) {
  // Style differently
}
```

