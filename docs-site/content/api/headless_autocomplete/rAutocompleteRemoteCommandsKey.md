---
title: "rAutocompleteRemoteCommandsKey constant"
description: "API documentation for the rAutocompleteRemoteCommandsKey constant from headless_autocomplete"
category: "Constants"
library: "headless_autocomplete"
outline: false
---

# rAutocompleteRemoteCommandsKey

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="type">dynamic</span> <span class="fn">rAutocompleteRemoteCommandsKey</span></div></div>

Feature key for remote commands in request features.

Use this key to get remote commands in slots/presets:

```dart
final commands = ctx.features.get(rAutocompleteRemoteCommandsKey);
commands?.retry();
```

