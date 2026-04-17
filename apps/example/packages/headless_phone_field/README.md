# headless_phone_field

Headless phone input adapted from [`phone_form_field`](https://pub.dev/packages/phone_form_field)
for the Headless architecture.

## What is preserved

- localized phone parsing via `phone_numbers_parser`
- country-aware formatting while typing
- plus-paste detection and country switching
- country selector orchestration
- built-in validation helpers
- controller-driven phone logic
- country max-length limiting

## What moved out of the behavior layer

- field visuals
- country trigger visuals
- slot placement of the country trigger
- choice of page / dialog / bottom-sheet selector UX

Those are now controlled through:

- `RPhoneField`
- `RPhoneFieldController`
- `RPhoneFieldCountrySelectorNavigator`
- `RPhoneFieldStyle`
- `countryButtonBuilder`
- `RenderOverrides` passed into the underlying `RTextField`

## Why this is interesting

The component keeps the hard parts of phone input behavior, but it no longer
locks consumers into one trigger design or one selector flow.

The same phone logic can be reused with:

- different Headless text-field renderers
- custom flag / dial-code triggers
- different slot placements
- custom country-picking UIs

## Demo wiring

The example app shows:

- one field switching between page / dialog / sheet selector strategies
- a branded custom country trigger
- controller-driven parsing and normalization
