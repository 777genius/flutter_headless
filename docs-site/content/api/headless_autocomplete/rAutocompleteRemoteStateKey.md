---
title: "rAutocompleteRemoteStateKey constant"
description: "API documentation for the rAutocompleteRemoteStateKey constant from headless_autocomplete"
category: "Constants"
library: "headless_autocomplete"
outline: false
---

# rAutocompleteRemoteStateKey

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="type">dynamic</span> <span class="fn">rAutocompleteRemoteStateKey</span></div></div>

Feature key for remote state in request features.

Use this key to read remote state in slots/presets:

```dart
final remoteState = ctx.features.get(rAutocompleteRemoteStateKey);
```

