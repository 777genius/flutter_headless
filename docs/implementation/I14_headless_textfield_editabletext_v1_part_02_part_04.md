## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split) (part 2) (part 4)

Back: [Index](./I14_headless_textfield_editabletext_v1_part_02.md)

- layout: padding/minSize/spacings/borderWidth
- paint: colors/textStyles/elevation

Рекомендация v1:
- держать поля отдельно (как в списке ResolvedTokens) и документировать “что может повлиять на размер”.

#### 4.1 InputFormatters — кто их применяет

**Важно**: Форматтеры применяются **самим `EditableText`** через его `inputFormatters` prop, а не компонентом вручную.

```dart
// Компонент просто передаёт formatters в EditableText
EditableText(
  controller: _controller,
  inputFormatters: widget.inputFormatters,  // ← Flutter применяет их
  ...
)
```

**Компонент отвечает только за:**
1. Прослушивание `_controller` изменений
2. Вызов `onChanged` без дублирования (см. 2.2.1)
3. Не вызывать `onChanged` если текст не изменился

**Почему НЕ применять форматтеры вручную:**
- `EditableText` применяет форматтеры на уровне `TextInputClient` с правильной обработкой selection
- Ручной вызов `_applyFormatters(String)` приводит к двойному форматированию, сломанному backspace, расхождению selection

**Тесты (widget tests):**
- T-FMT-1: Formatter применяется (digits-only фильтрует буквы)
- T-FMT-2: Formatter не вызывает infinite loop (last notified value check)
- T-FMT-3: Selection не сбрасывается после форматирования

#### 4.2 ObscureText (password) — нюансы v1

Тонкие моменты:
- selection/paste поведение в password полях отличается
- semantics не должны “озвучивать” пароль (value/hint должны быть осторожными)

Политика v1:
- `obscureText=true` не включает “показать пароль” — это отдельная фича/preset/UI.
- renderer может показывать trailing icon через slot, но поведение (toggle) — вне core v1.

#### 4.3 Autofill (prod must-have)

Если есть `autofillHints`:
- компонент должен прокидывать их в EditableText/TextInputConfiguration
- в controlled режиме быть аккуратным: autofill может поменять текст “снаружи”, нельзя ломать composing/selection.

---

### 5) A11y и семантика

Компонент должен обеспечивать:
- правильную `Semantics` роль текстового поля,
- label/hint/error (на уровне Semantics),
- корректную работу с screen readers.

#### 5.1 Semantics для error

**Требование**: `errorText` должен быть доступен в semantics, не только визуально.

**Принцип (не конкретная строка):**
- Screen reader должен иметь возможность получить error message
- Конкретный способ (concatenation, separate announcement, live region) — implementation detail

**Возможные подходы (выбрать при реализации):**
- `Semantics.value` включает error
- `Semantics.liveRegion` для динамического announcement
- Error label как отдельный Semantics node

**Тест**:
- T-A11Y-ERR: Widget test проверяет что error text доступен в semantics tree

#### 5.2 Semantics для password

Политика v1:
- если `obscureText=true`, semantics не должны включать реальный текст
- errorText при этом всё равно должен быть доступен

---

