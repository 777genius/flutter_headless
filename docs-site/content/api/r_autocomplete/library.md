---
title: "r_autocomplete"
description: "API documentation for the r_autocomplete library"
outline: [2, 3]
---

# r_autocomplete

## Classes {#section-classes}

| Class | Description |
|---|---|
| [RAutocomplete\<T\>](/api/src_presentation_r_autocomplete/RAutocomplete) | Headless autocomplete (input + menu). |
| [RAutocompleteCombinePolicy](/api/src_sources_r_autocomplete_policies/RAutocompleteCombinePolicy) | Policy for combining local and remote results in hybrid mode. |
| [RAutocompleteHybridSource\<T\>](/api/src_sources_r_autocomplete_source/RAutocompleteHybridSource) | Hybrid source combining local and remote sources. |
| [RAutocompleteLocalPolicy](/api/src_sources_r_autocomplete_policies/RAutocompleteLocalPolicy) | Policy for local source behavior. |
| [RAutocompleteLocalSource\<T\>](/api/src_sources_r_autocomplete_source/RAutocompleteLocalSource) | Local synchronous source for autocomplete options. |
| [RAutocompleteQueryPolicy](/api/src_sources_r_autocomplete_policies/RAutocompleteQueryPolicy) | Query normalization policy shared between local and remote sources. |
| [RAutocompleteRemoteCacheLastSuccessfulPerQuery](/api/src_sources_r_autocomplete_policies/RAutocompleteRemoteCacheLastSuccessfulPerQuery) | Cache last successful result per query text. |
| [RAutocompleteRemoteCacheNone](/api/src_sources_r_autocomplete_policies/RAutocompleteRemoteCacheNone) | No caching policy. |
| [RAutocompleteRemoteCachePolicy](/api/src_sources_r_autocomplete_policies/RAutocompleteRemoteCachePolicy) | Cache policy for remote source results. |
| [RAutocompleteRemoteCommands](/api/src_sources_r_autocomplete_remote_commands/RAutocompleteRemoteCommands) | Commands for interacting with the remote source. |
| [RAutocompleteRemoteError](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteError) | Remote error information for UI display. |
| [RAutocompleteRemotePolicy](/api/src_sources_r_autocomplete_policies/RAutocompleteRemotePolicy) | Policy for remote source behavior. |
| [RAutocompleteRemoteQuery](/api/src_sources_r_autocomplete_remote_query/RAutocompleteRemoteQuery) | Query information passed to remote load callbacks. |
| [RAutocompleteRemoteSource\<T\>](/api/src_sources_r_autocomplete_source/RAutocompleteRemoteSource) | Remote asynchronous source for autocomplete options. |
| [RAutocompleteRemoteState](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState) | Current state of the remote source. |
| [RAutocompleteRemoteStateIndicator](/api/src_presentation_r_autocomplete_remote_state_indicator/RAutocompleteRemoteStateIndicator) |  |
| [RAutocompleteSectionId](/api/src_sources_r_autocomplete_item_features/RAutocompleteSectionId) | Section identifier for grouped display. |
| [RAutocompleteSource\<T\>](/api/src_sources_r_autocomplete_source/RAutocompleteSource) | Sealed base class for autocomplete data sources. |

## Enums {#section-enums}

| Enum | Description |
|---|---|
| [RAutocompleteDedupePreference](/api/src_sources_r_autocomplete_policies/RAutocompleteDedupePreference) | How to prefer items when deduplicating in hybrid mode. |
| [RAutocompleteItemSource](/api/src_sources_r_autocomplete_item_features/RAutocompleteItemSource) | Source of an autocomplete item (local or remote). |
| [RAutocompleteRemoteErrorKind](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteErrorKind) | Kind of remote error for UI display. |
| [RAutocompleteRemoteStatus](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteStatus) | Status of the remote source. |
| [RAutocompleteRemoteTrigger](/api/src_sources_r_autocomplete_remote_query/RAutocompleteRemoteTrigger) | What triggered a remote load request. |

## Constants {#section-constants}

| Constant | Description |
|---|---|
| [rAutocompleteItemSourceKey](/api/headless_autocomplete/rAutocompleteItemSourceKey) | Feature key for item source in item features. |
| [rAutocompleteRemoteCommandsKey](/api/headless_autocomplete/rAutocompleteRemoteCommandsKey) | Feature key for remote commands in request features. |
| [rAutocompleteRemoteStateKey](/api/headless_autocomplete/rAutocompleteRemoteStateKey) | Feature key for remote state in request features. |
| [rAutocompleteSectionIdKey](/api/headless_autocomplete/rAutocompleteSectionIdKey) | Feature key for section ID in item features. |

