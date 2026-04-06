---
title: "buildAutocompleteItemModel<T> function"
description: "API documentation for the buildAutocompleteItemModel<T> function from autocomplete_item_model_factory"
category: "Functions"
library: "autocomplete_item_model_factory"
outline: false
---

# buildAutocompleteItemModel\<T\>

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">dynamic</span> <span class="fn">buildAutocompleteItemModel&lt;T&gt;</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">adapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">T</span> <span class="param">value</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">id</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">additionalFeatures</span>,</span><span class="member-signature-line">});</span></div></div>

Builds a [HeadlessListItemModel](/api/src_listbox_headless_list_item_model/HeadlessListItemModel) from an item using the adapter.

If `additionalFeatures` is provided, it will be merged with the adapter's
features. Additional features take precedence on collision.

