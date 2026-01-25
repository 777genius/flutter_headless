## I14 — Component v1: Headless TextField на базе `EditableText` (contracts + renderer split) (part 2) (part 3)

Back: [Index](./I14_headless_textfield_editabletext_v1_part_02.md)


**Правила:**
- `widget.value == _controller.text` → **ничего не делаем** (idempotent)
- `composing.isValid` → **откладываем** в `_pendingValue`, не перезаписываем
- selection сохраняем и clamp'им (если valid)

#### 2.2.1 Обработка `onChanged` (без двойных вызовов)

**Критичное правило v1:**
- `onChanged` вызывается **только** на реальные изменения текста
- **Никогда** не вызывать `onChanged` в ответ на sync из `didUpdateWidget` (иначе цикл)
- Форматтеры применяются самим `EditableText` (см. 4.1)

```dart
void _handleControllerChanged() {
  final currentText = _controller.text;

  // Не уведомлять о том же значении
  if (currentText == _lastNotifiedValue) {
    return;
  }

  _lastNotifiedValue = currentText;
  widget.onChanged?.call(currentText);
}
```

#### 2.3 IME Composing — ограничения тестирования

**Проблема**: CJK ввод с composing region сложно стабильно симулировать в widget tests.

**Политика v1:**
- Кодовая политика (pending value + no overwrite) — **обязательна**
- Widget test может проверить `composing.isValid` logic через mock `TextEditingValue`
- Реальная проверка CJK — **manual test** на устройстве/эмуляторе
- Документировать в CONFORMANCE_REPORT.md

#### 2.4 Multiline — v1 scope

**Поддерживается**:
- `maxLines` / `minLines`
- Scroll внутри поля

**Отложено (YAGNI для v1)**:
- Auto-grow (dynamic height)
- Идеальный scroll-into-view при курсоре

**Дефолт**: `maxLines: 1` (single-line)

#### 2.5 Валидация (v1 решение)

**v1 выбор: Option A (external errorText)**

Пользователь сам передаёт `errorText` снаружи. Компонент не содержит validator/autovalidateMode.

Обоснование:
- Простота: нет внутреннего state для validation
- Предсказуемость: parent полностью контролирует когда показывать ошибку
- Form integration: можно использовать с любым form solution (FormBuilder, Riverpod forms, etc.)
- Тестируемость: widget tests не зависят от validation timing

**Что это означает:**
- `errorText != null` → `state.isError = true` → tokens меняют цвета border/label
- `errorText` передаётся в semantics
- Нет `validator` prop, нет `autovalidateMode`

**v1.1+ рассмотреть:**
- `validator: String? Function(String)?` + `autovalidateMode` (Form-friendly)
- Но только как additive change, не ломая v1 поведение

---

### 3) Поведение/ядро: `EditableText`

Компонент:
- владеет activation и state,
- использует `EditableText` для:
  - IME интеграции,
  - selection/clipboard,
  - курсор/scroll into view,
  - keyboard shortcuts.

Renderer получает:
- resolvedTokens
- state/spec
- commands/slots
- и “child ядро” (например, уже созданный `EditableText`), либо наоборот: renderer строит декорацию вокруг, а компонент вставляет `EditableText` в нужное место.

Тонкий момент (важно выбрать один путь):
- Вариант A (проще для инвариантов): компонент создаёт `EditableText`, renderer его “оборачивает”.
- Вариант B (больше свободы preset’у): renderer создаёт `EditableText` (опаснее: может сломать инварианты).

Для v1: **Вариант A**.

#### 3.1 Focus ownership и lifecycle (v1)

- если `focusNode` передан извне — компонент **не dispose**’ит его
- если `focusNode` внутренний — dispose в `dispose()`
- при `enabled=false` или `readOnly=true`:
  - focus поведение должно быть предсказуемым (POLA): можно фокусировать readOnly, но нельзя вводить

#### 3.2 Keyboard shortcuts (v1)

P0 для прод-форм:
- Ctrl/Cmd+A (select all)
- Ctrl/Cmd+C/V/X (copy/paste/cut) — работает через EditableText
- Escape — не обязателен, но полезен для очистки focus (опционально)

Тонкий момент:
- не пытаться реализовывать собственный shortcut system: используем то, что даёт `EditableText`/Flutter, и только дополняем при необходимости.

#### 3.3 Scroll-into-view (v1)

Минимум:
- caret не должен уходить “за экран” при вводе
- для multiline: scroll внутри поля должен работать

Если это сложно для v1:
- фиксируем, что “идеальный scroll-into-view” — v1.1+

#### 3.4 Clipboard / Selection handles (v1)

Политика v1:
- не переписываем selection/copy/paste руками — используем `EditableText` как источник истины.

Edge cases:
- `readOnly=true`:
  - выделение/копирование разрешено (POLA),
  - вставка/вырезание запрещены.
- `enabled=false`:
  - взаимодействие no-op, фокус не ставим.

---

### 4) Tokens + Overrides

`RTextFieldTokenResolver.resolve(...)` принимает:
- `spec`
- `states` (focus/hover/disabled/error)
- `constraints`
- `overrides` (RenderOverrides?)

Приоритет:
1) `RTextFieldOverrides` (contract)
2) preset-specific (опционально, advanced)
3) defaults

Тонкие моменты:
- `errorText != null` должен отражаться в `state` и токенах (цвет бордера/label/error).
- `readOnly` — отдельный визуальный state (часто другой cursor/цвет).

#### 4.0 ResolvedTokens должны покрывать “структурные” параметры

Чтобы была “огромная гибкость”, resolvedTokens v1 должны включать минимум:
- container: padding, borderRadius, borderColor, backgroundColor, shadow/elevation (если preset поддерживает)
- label/helper/error: textStyle + colors + spacing
- input text: textStyle, cursorColor, selectionColor
- icon slots: iconColor + spacing

Это позволяет:
- менять вид без добавления десятков пропсов,
- а per-instance overrides остаются контрактными.

#### 4.0.1 Точная спецификация `RTextFieldResolvedTokens` (v1 минимум)

Чтобы preset’ы были взаимозаменяемыми, `RTextFieldResolvedTokens` должен иметь стабильный набор полей.
Предлагаемый v1 минимум (все поля required внутри ResolvedTokens):

**Container**
- `containerPadding: EdgeInsetsGeometry`
- `containerBackgroundColor: Color`
- `containerBorderColor: Color`
- `containerBorderRadius: BorderRadius`
- `containerBorderWidth: double`
- `containerElevation: double` (может быть 0)

**Label / Helper / Error**
- `labelStyle: TextStyle`
- `labelColor: Color`
- `helperStyle: TextStyle`
- `helperColor: Color`
- `errorStyle: TextStyle`
- `errorColor: Color`
- `messageSpacing: double` (gap между input и helper/error)

**Input**
- `textStyle: TextStyle`
- `textColor: Color`
- `placeholderStyle: TextStyle`
- `placeholderColor: Color`
- `cursorColor: Color`
- `selectionColor: Color`
- `disabledOpacity: double` (или отдельные disabled цвета — на усмотрение preset)

**Icons / Slots**
- `iconColor: Color`
- `iconSpacing: double`

**Sizing**
- `minSize: Size` (hit target policy)

**Constraints / Hit Target Policy (как в I09):**
- Component задаёт baseline hit target (e.g., 48x48 для accessibility)
- Resolver может увеличить через `minSize` token
- Renderer **обязан применить** constraints — не игнорировать
- Порядок: `component baseline → resolver minSize → max(baseline, minSize)`

Тонкий момент:
- v1 поля лучше держать "плоскими", без глубоких деревьев классов, чтобы overrides были простыми.

##### 4.0.1.1 ResolvedTokens Policy (v1 vs v1.1+)

**v1 минимум (обязательные поля):**
- Container: padding, backgroundColor, borderColor, borderRadius, borderWidth
- Input: textStyle, textColor, cursorColor, selectionColor
- Labels: labelStyle, labelColor, errorStyle, errorColor
- Sizing: minSize

**v1.1+ кандидаты (не включать в v1):**
- `focusedBorderWidth` (сейчас hardcoded 2x)
- `labelFloatingStyle` (floating label animation)
- `counterStyle/counterColor` (character counter)

**Правило additive-only:**
- Новые поля добавляются как nullable с default fallback
- Существующие required поля НЕЛЬЗЯ удалять/менять тип
- Preset должен работать если новое поле = null

#### 4.0.2 Как работают `RTextFieldOverrides` (patch policy)

`RTextFieldOverrides` должен быть “token patch”:
- каждое поле nullable
- resolver берёт base tokens и применяет patch (overrides) поверх

Правило:
- overrides не должны менять поведение (focus/IME/selection), только визуал/лейаут.

#### 4.0.3 Разделение “layout tokens” vs “paint tokens” (для гибкости)

Чтобы per-instance overrides не ломали layout, полезно разделять:
