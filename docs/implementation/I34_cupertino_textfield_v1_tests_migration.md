# I34 (part 3) — Тесты, демо, migration и критерии готовности

## 0) Что уже есть (важно не дублировать)

В `headless_textfield` уже есть сильная тестовая база, на которую нужно опереться и расширить:

- компонентные тесты `RTextField`:
  - `packages/components/headless_textfield/test/r_text_field_test.dart`
- conformance по a11y SLA:
  - `packages/components/headless_textfield/test/conformance_a11y_sla_test.dart`

Следствие:

- новую “поведенческую” функциональность (P0 из part 1) тестируем там же;
- новые cupertino‑визуальные affordances тестируем в `headless_cupertino`.

---

## 1) Тест‑матрица (P0) — конкретные сценарии и где они живут

### 1.1 `packages/components/headless_textfield` (поведение/EditableText)

Добавляем тесты на новые props, которые прокидываются в `EditableText`:

- `onEditingComplete` вызывается при `tester.testTextInput.receiveAction(TextInputAction.done)`
- `onTapOutside` вызывается при тапе вне поля, когда поле в фокусе
- `maxLength`/`maxLengthEnforcement` реально ограничивают ввод
- `autocorrect/enableSuggestions/textCapitalization/smartQuotes/smartDashes` прокинуты (проверка через `EditableText` виджет в дереве)
- `showCursor/keyboardAppearance/scrollPadding/dragStartBehavior/enableInteractiveSelection` прокинуты (проверка параметров `EditableText`)

Файлы:

- расширяем `packages/components/headless_textfield/test/r_text_field_test.dart`

### 1.2 `packages/headless_cupertino/test` (preset: renderer/resolver)

Новые тесты (P0):

1) **Capabilities present**

- `CupertinoHeadlessTheme().capability<RTextFieldRenderer>() != null`
- `CupertinoHeadlessTheme().capability<RTextFieldTokenResolver>() != null`

2) **Token resolver state mapping**

- focused → borderColor меняется на primary
- disabled → opacity/цвета меняются предсказуемо
- borderless override → borderWidth/background прозрачные

3) **Clear button**

Собираем виджет с `HeadlessThemeProvider(theme: CupertinoHeadlessTheme())` и `RTextField` + renderer cupertino:

- вводим текст,
- убеждаемся, что clear появился при `clearButtonMode` (editing/always),
- тап по clear вызывает `commands.clearText` → текст стал пустым.

Дополнительно (P0, чтобы не поймать IME-баги):

- после clear:
  - selection = collapsed(0)
  - composing = empty
  - фокус остаётся (нет blur)

4) **OverlayVisibilityMode: prefix/suffix/clear**

- `prefixMode/suffixMode`: `always/editing/notEditing/never` работают от “editing state”
  (см. определения в `I34_cupertino_textfield_v1_ui_preset.md`).
- `clearButtonMode`: те же режимы + дополнительное условие `hasText == true`.

5) **maxLength без двойного лимитера**

- Если задан `maxLength`, компонент добавляет `LengthLimitingTextInputFormatter`.
- Если пользователь уже передал `LengthLimitingTextInputFormatter` в `inputFormatters`, компонент не добавляет второй.
  - если значения разные, выигрывает пользовательский limiter.

Файлы (предлагаемые):

- `packages/headless_cupertino/test/cupertino_textfield_capabilities_test.dart`
- `packages/headless_cupertino/test/cupertino_textfield_tokens_test.dart`
- `packages/headless_cupertino/test/cupertino_textfield_clear_button_test.dart`

### 1.3 `apps/example/test` (DX smoke)

Это “тест пользователя”:

- переключаемся Material → Cupertino в демо
- открываем `TextField Demo` и `Autocomplete Demo`
- убеждаемся, что не прилетает `MissingCapabilityException`

Примечание: этот тест должен быть максимально коротким и устойчивым, без привязки к пиксель‑дереву.

---

## 2) Демо и документация (P0)

### 2.1 Example app

Обновить `TextField Demo` (в `apps/example/lib/screens/textfield_demo_screen.dart` или соответствующем виджете):

- `RCupertinoTextField` (default)
- `RCupertinoTextField.borderless`
- примеры `prefix/suffix` и режимов `prefixMode/suffixMode/clearButtonMode`

### 2.2 Cookbook

Обновить `docs/users/COOKBOOK_TEXTFIELD.md`:

- рецепт “как заменить `CupertinoTextField` на `RCupertinoTextField`”
- таблица маппинга из part 1

---

## 3) Migration план (P0 → P1) — в правильном порядке

### Шаг A (контракты и поведение — чтобы preset мог опираться на API)

- `RTextFieldSpec`: добавить `clearButtonMode/prefixMode/suffixMode`
- `RTextFieldCommands`: добавить `clearText`
- `RTextField`: добавить P0 props и прокинуть в `EditableText`
- дописать тесты в `components/headless_textfield/test/`

### Шаг B (cupertino preset UI)

- реализовать `CupertinoTextFieldTokenResolver`
- реализовать `CupertinoTextFieldRenderer` + primitives
- зарегистрировать в `CupertinoHeadlessTheme.capability<T>()`
- добавить preset‑тесты в `headless_cupertino/test/`

### Шаг C (DX)

- добавить `RCupertinoTextField` и экспорт
- обновить example app demos
- обновить cookbook

### Шаг D (после P0)

- убрать любые временные “fallback” решения из example app (если были) и оставить только полноценный preset.

---

## 3.1 Разбиение на PR’ы (чтобы ревью было быстрым и безопасным)

### PR1 — Contracts + Component behavior (core)

Scope:

- `headless_contracts`: `RTextFieldSpec` + `RTextFieldCommands.clearText`
- `headless_textfield`: новые props + прокидывание в `EditableText` + `maxLength` через formatter
- тесты: расширить `packages/components/headless_textfield/test/r_text_field_test.dart`

Acceptance:

- всё собирается без `headless_cupertino` изменений
- Material preset не затронут по поведению (кроме новых default props, которые не меняют старое)

### PR2 — `headless_cupertino`: renderer + resolver + theme registration

Scope:

- `CupertinoTextFieldTokenResolver` / `CupertinoTextFieldRenderer` + primitives
- регистрация capabilities в `CupertinoHeadlessTheme`
- preset-тесты в `packages/headless_cupertino/test/`

Acceptance:

- `CupertinoHeadlessTheme` предоставляет `RTextFieldRenderer` и `RTextFieldTokenResolver`
- clear button (если включён policy) вызывает `commands.clearText`

### PR3 — DX: wrapper + example + docs

Scope:

- `RCupertinoTextField` (+ `.borderless`) и экспорт
- обновление example app (TextField demo + smoke тест)
- обновление `docs/users/COOKBOOK_TEXTFIELD.md`

Acceptance:

- пользователь может заменить `CupertinoTextField` на `RCupertinoTextField` “один к одному” по базовым кейсам

---

## 4) Definition of Done (DoD)

- [ ] `melos run analyze`
- [ ] `melos run test`
- [ ] Все новые P0 тесты зелёные (component + preset + example smoke)
- [ ] В example app переключение темы не ломает TextField/Autocomplete
- [ ] Обновлены cookbook + (опционально) changelog

---

## 5) Риски и контроль

### “Раздуем `RTextField`”

Контроль:

- P0 — только свойства, которые напрямую конфигурируют `EditableText`
- всё визуальное — исключительно в preset tokens/overrides/slots

### “Clear сломает controlled режим”

Контроль:

- `commands.clearText` реализуется внутри компонента через существующую синхронизацию (не через прямой доступ renderer’а к controller)
- отдельный тест на controlled mode: clear → `onChanged('')`

### “Визуал не похож”

Контроль:

- сначала фиксируем структуру/режимы видимости/состояния (focused/disabled/error)
- затем подкручиваем **только token resolver** (renderer не трогаем)

