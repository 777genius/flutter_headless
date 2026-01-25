# Guardrails for customization

This page explains the rules that keep behavior and accessibility correct when you customize visuals.

## Ownership (who is responsible for what)

If you violate these, you can get double activation, broken keyboard support, or broken overlays.

| Concern | Owner | Notes |
|---|---|---|
| Tap/keyboard activation | **Component** | Renderers and primitives must not create a second activation path. |
| Selection triggering (`selectIndex`) | **Component / safe scaffold** | Item widgets should not “select” manually. |
| Overlay close contract (`completeClose`) | **Renderer / safe scaffold** | If you animate exit, you must call `completeClose()` after the animation. |
| Component semantics (button/selected/enabled) | **Component (baseline)** | Renderers may add local semantics only if it cannot cause double activation. |

## Safe path (recommended)

Most customization should use **slots** (`Decorate` first) and **primitives**.

- Use **Decorate** when you want to wrap the default UI.
- Use **Replace** only if you know you can keep semantics/commands/close-contract correct.

## What not to do (common footguns)

- Do not put `onTap` / `onPressed` on renderer roots.
- Do not add tap handlers inside dropdown menu items (safe scaffolds own selection).
- Do not implement your own overlay lifecycle in a primitive.
- Do not forget `completeClose()` if you animate exit.

## Debugging

### “Close contract timeout”

If you see a log similar to:

```
[AnchoredOverlayEngine] Close contract timeout: renderer did not call completeClose().
```

It means:
- the overlay entered `closing`,
- but the renderer never called `completeClose()`.

Fix:
- call `commands.completeClose()` after your exit animation finishes,
- or use a safe scaffold that manages the close contract for you.

### Double activation

Symptoms:
- callbacks fire twice,
- selection happens twice,
- focus jumps unexpectedly.

Fix:
- ensure there is exactly one activation source: the component.
- remove tap handlers from renderer roots and primitives.

## Repo hygiene (локальные артефакты)

Локальные build/IDE артефакты **могут** появляться во время разработки (например после `flutter test`),
но **не должны** попадать в git.

- **MUST**: `build/`, `.dart_tool/`, `*.iml`, `.idea/`, `.vscode/` должны быть в `.gitignore`.
- **MUST**: перед PR/коммитом убедиться, что в diff нет артефактов сборки/IDE.
