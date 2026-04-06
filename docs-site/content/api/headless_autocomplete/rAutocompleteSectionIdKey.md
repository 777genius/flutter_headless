---
title: "rAutocompleteSectionIdKey constant"
description: "API documentation for the rAutocompleteSectionIdKey constant from headless_autocomplete"
category: "Constants"
library: "headless_autocomplete"
outline: false
---

# rAutocompleteSectionIdKey

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="type">dynamic</span> <span class="fn">rAutocompleteSectionIdKey</span></div></div>

Feature key for section ID in item features.

Use this key to read section ID in renderers for grouping:

```dart
final sectionId = item.features.get(rAutocompleteSectionIdKey);
// Group items by sectionId
```

