# headless_pinput

Headless OTP / PIN input adapted from [`pinput`](https://pub.dev/packages/pinput)
for the Headless architecture.

## What is preserved

- completion detection
- validation flow
- hidden `EditableText` ownership
- clipboard / code retriever hooks
- per-cell state mapping
- custom keyboard support
- typed variant intent

## What moved out of the behavior layer

- cell visuals
- borders and shadows
- cursor paint
- preset styling families

Those are now handled by:

- `RPinInputRenderer`
- `RPinInputTokenResolver`
- `RenderOverrides`
- `RPinInputStyle`

## Demo wiring

This package ships demo-only visual wiring for the example app:

- `DemoPinInputRenderer`
- `DemoPinInputTokenResolver`

They are not required by the component itself. Any consumer can provide their
own renderer and token resolver through `HeadlessTheme`.
