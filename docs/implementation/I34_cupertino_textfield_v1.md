# I34 — Cupertino TextField v1: визуальный parity + API-обёртка в стиле `CupertinoTextField`

Этот документ — план итерации по реализации Cupertino-визуала для `RTextField`, с API, максимально похожим на Flutter `CupertinoTextField`, но адаптированным под нашу headless-архитектуру.

Ссылка на оригинальную документацию Flutter: [`CupertinoTextField`](https://api.flutter.dev/flutter/cupertino/CupertinoTextField-class.html).

## TL;DR (что получится в конце)

- В `headless_cupertino` появится полноценный preset для textfield:
  - `CupertinoTextFieldRenderer` + `CupertinoTextFieldTokenResolver`
  - registration в `CupertinoHeadlessTheme`
- Появится DX‑обёртка `RCupertinoTextField` (и `.borderless`) с неймингом близким к `CupertinoTextField`,
  но реализованная через:
  - `RTextField` (поведение),
  - tokens/overrides/slots (визуал).

## Готовность к реализации

**Оценка: 9.5/10.**

Политика совместимости (пока pre-release):

- Можно делать **breaking изменения**, если это улучшает архитектуру и снижает долг.
- После публикации пакетов переключаемся на “аддитивность по умолчанию” (POLA + SemVer).

Что уже достаточно специфицировано, чтобы писать код без сюрпризов:

- contracts (`spec` policy + `commands.clearText`);
- P0 props `RTextField` (что и как прокидываем в `EditableText`);
- cupertino preset UI (tokens → renderer) + `borderless` семантика;
- тест‑матрица (включая tricky кейсы: `OverlayVisibilityMode`, `maxLength` без двойного лимитера, `clearText` selection/composing).

Что остаётся уточнить при первой реализации (не блокирует старт, но важно закрыть до “готово”):

- точные параметры дефолтной `BoxDecoration` у Flutter `_kDefaultRoundedBorderDecoration` (радиус/граница) и насколько мы хотим совпадать;
- финальное решение по `CupertinoTextFieldOverrides.decorationOverride` (держим ли в P0 или оставляем P1, чтобы не ломать “tokens-only” дисциплину).

## Части

- [Part 1 — API и контракты](./I34_cupertino_textfield_v1_api_contracts.md)
- [Part 2 — Реализация UI (preset)](./I34_cupertino_textfield_v1_ui_preset.md)
- [Part 3 — Тесты и migration](./I34_cupertino_textfield_v1_tests_migration.md)

