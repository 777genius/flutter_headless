# headless_contracts

Renderer contracts and slot override APIs for Headless components.

This package defines the request/response boundary between component behavior
and visual rendering. Presets such as `headless_material` and
`headless_cupertino` implement these contracts.

Use this package when you want to:

- write a custom renderer for an existing Headless component
- provide per-instance visual overrides
- compose slots without changing interaction behavior
