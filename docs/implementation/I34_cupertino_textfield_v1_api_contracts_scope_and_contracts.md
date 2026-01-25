# I34 (part 1.1) — Scope/решения + изменения contracts

Оригинальная дока Flutter: [`CupertinoTextField`](https://api.flutter.dev/flutter/cupertino/CupertinoTextField-class.html).

## 0) Реальная база (на что опираемся в коде)

Перед началом итерации фиксируем текущие “границы ответственности” в коде:

- **Компонент** `RTextField` (поведение + `EditableText`):
  - `packages/components/headless_textfield/lib/src/presentation/r_text_field.dart`
  - `packages/components/headless_textfield/lib/src/presentation/r_text_field_editable_text_factory.dart`
- **Контракты** renderer/token resolver/spec/commands:
  - `packages/headless_contracts/lib/src/renderers/textfield/`
- **Material preset** (референс “как правильно”):
  - `packages/headless_material/lib/src/textfield/material_text_field_renderer.dart`
  - `packages/headless_material/lib/src/textfield/material_text_field_token_resolver.dart`
- **Cupertino preset** сейчас НЕ покрывает textfield:
  - `packages/headless_cupertino/lib/src/cupertino_headless_theme.dart`

---

## 1) Цели / scope

### P0 (обязательное)

- `CupertinoHeadlessTheme` предоставляет:
  - `RTextFieldRenderer`
  - `RTextFieldTokenResolver`
- Визуальный baseline “как у `CupertinoTextField`”:
  - rounded border по умолчанию,
  - `borderless`,
  - padding‑ориентир: `EdgeInsets.all(7.0)` (из Flutter docs),
  - clear button с режимом видимости,
  - cupertino‑цвета cursor/selection/placeholder.
- DX‑обёртка: `RCupertinoTextField` (и `.borderless`) с узнаваемым неймингом.

### Anti-scope

- 100% покрытие всех свойств Flutter `CupertinoTextField`.
- Пиксель‑перфект “везде и сразу”.
- Любая логика изменения текста в renderer (строго запрещено).

---

## 2) Главные решения

### 2.1 `RCupertinoTextField` — публичный API, `RTextField` — универсальное ядро

Мы НЕ превращаем `RTextField` в клон `CupertinoTextField`. Вместо этого:

- `RCupertinoTextField` живёт в `headless_cupertino`,
- он маппит:
  - **поведение** → props `RTextField`,
  - **визуал** → preset overrides + slots.

### 2.2 Что считаем “визуалом”

Визуальные параметры не добавляем в `RTextField` props.

Исключение: **policy видимости affordances** (prefix/suffix/clear) — renderer должен принимать решение, значит policy должен прийти в `spec`.

Дополнительно (v1):

- `RTextFieldSpec.variant` — это **intent**, не “точный iOS пиксель‑перфект вид”.
- Cupertino preset может маппить `variant` в ближайший нативный вид.
- Если нужны дополнительные режимы (например, grouped/inset/plain), они должны быть реализованы через `CupertinoTextFieldOverrides` (preset-specific), а не через расширение `RTextFieldVariant`.

---

## 3) Contracts (P0)

### 3.1 `RTextFieldSpec`: policy видимости affordances

Файл: `packages/headless_contracts/lib/src/renderers/textfield/r_text_field_renderer.dart`

Добавляем поля в `RTextFieldSpec`:

- `OverlayVisibilityMode clearButtonMode = OverlayVisibilityMode.never`
- `OverlayVisibilityMode prefixMode = OverlayVisibilityMode.always`
- `OverlayVisibilityMode suffixMode = OverlayVisibilityMode.always`

Точная сигнатура:

```dart
final class RTextFieldSpec {
  const RTextFieldSpec({
    // ...existing...
    this.clearButtonMode = OverlayVisibilityMode.never,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffixMode = OverlayVisibilityMode.always,
  });

  final OverlayVisibilityMode clearButtonMode;
  final OverlayVisibilityMode prefixMode;
  final OverlayVisibilityMode suffixMode;
}
```

### 3.2 `RTextFieldCommands`: очистка текста

Файл: `packages/headless_contracts/lib/src/renderers/textfield/r_text_field_commands.dart`

Добавляем:

- `VoidCallback? clearText`

Точная сигнатура:

```dart
final class RTextFieldCommands {
  const RTextFieldCommands({
    this.tapContainer,
    this.tapLeading,
    this.tapTrailing,
    this.clearText,
  });

  final VoidCallback? clearText;
}
```

Инвариант:

- renderer не трогает controller напрямую; только `commands.clearText?.call()`.

---

## 4) Как contracts попадают в runtime (критично)

Сейчас `spec` собирается в:

- `packages/components/headless_textfield/lib/src/presentation/r_text_field_request_composer.dart` → `createSpec(...)`

Там же нужно:

- выставить дефолты и прокинуть новые policy поля из `RTextField` props в `RTextFieldSpec`.

---

## 5) Политика совместимости (pre-release)

Пока мы **в процессе разработки** и пакеты ещё **не опубликованы** (нет стабильного SemVer контракта),
мы допускаем **breaking изменения**, если так архитектурно лучше.

Правило для этой итерации:

- **Можно** ломать совместимость ради чистоты контрактов/архитектуры (например, переименования, изменение типов, перенос ответственности).
- **Нельзя** ломать инварианты headless‑границ (component vs renderer) и требования Spec (semantics/commands/tokens).

Когда будем готовиться к публикации/релизу:

- возвращаемся к политике “аддитивность по умолчанию” (новые поля только с дефолтами, команды optional, без изменения поведения по умолчанию),
  как это описано в `docs/SPEC_V1.md` и `docs/v1_decisions/*` (про снижение breaking changes и POLA).

