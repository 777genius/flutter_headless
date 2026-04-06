## V1 Decisions (зафиксировано перед реализацией) (part 1) (part 3)

Back: [Index](../V1_DECISIONS.md)

- **Focus restore**: при закрытии фокус возвращается предсказуемо (POLA).

#### Close contract v1 — A1 (зафиксировано)

**Цель:** exit‑анимации и a11y/focus инварианты должны работать всегда → оверлей не удаляется “мгновенно”.

#### Renderer phase API v1 — R1 + P2 (зафиксировано)

Чтобы тема могла корректно реализовать enter/exit (и не городить костыли), overlay обязан экспонировать фазу жизненного цикла как observable.

**Решение:**
- `OverlayHandle` предоставляет read‑only `ValueListenable<OverlayPhase> phase`.
- Фазы v1: `opening`, `open`, `closing`, `closed`.

**Инварианты:**
- `close()` переводит `phase` в `closing` (если был `opening/open`).
- `OverlayHandle.completeClose()` переводит `phase` в `closed` и удаляет subtree.
- `opening -> open` и `closing -> closed` должны быть детерминированными (без “мигающих” переходов).

**Контракт:**
- `OverlayHandle.close()` **не удаляет** overlay subtree сразу.
- `close()` переводит overlay в фазу **`closing`** (если он был `opening/open`).
- Пока overlay в `closing`, он:
  - остаётся в дереве,
  - продолжает участвовать в dismiss/focus политиках (по правилам компонента/оверлея),
  - может отрисовать exit‑анимацию через renderer.
- Завершение закрытия происходит **только** через явный сигнал:
  - `OverlayHandle.completeClose()` (вызывает удаление subtree из оверлея после завершения exit-анимации).

**Инварианты:**
- `close()` **идемпотентен**: повторный `close()` в `closing/closed` не ломает состояние.
- `OverlayHandle.completeClose()` безопасен к повторным вызовам (no-op после закрытия).
- `close()` не должен приводить к tight loop “measure → setState → measure” (см. perf guardrails).

**Fail-safe (обязателен):**
- Если `completeClose` не вызван (баг темы/рендера), механизм обязан закрыть overlay по **таймаут‑политике** (конфигурируемо) и залогировать проблему.
  - Это защита от “вечного closing”, утечек и блокировки UI.

**Оценка:** 9/10  
**Почему:** стабильный контракт для design-system уровня: управляемый lifecycle + тестируемость + корректная вложенность.

---

### 7) Dropdown state model v1: selection controlled + optional controller (open/highlight)

**Решение (зафиксировано):**
- `value/onChanged` — главный controlled контракт (как у Flutter).
- Дополнительно допускаем **опциональный controller** для `open/highlight` (без query).
- `query` — не часть DropdownButton v1; он появится в `Autocomplete` через `TextEditingController`/отдельный state.

**Оценка:** 9/10  
**Почему:** сохраняет Flutter‑like UX и оставляет простор для будущего.

---

### 8) Tokens: raw + semantic

**Решение (зафиксировано):** используем и raw, и semantic tokens.

**Оценка:** 9/10  
**Почему:** multi-brand невозможен без semantic‑слоя (иначе смысл зашивается в “primaryColor”).

**Статус:** структура semantic tokens v1 — **зафиксирована ниже (см. 8.2)**.

---

### 8.1) W3C Design Tokens (2025.10): ограничения импорта (для будущего CLI)

**Решение (зафиксировано):** при импорте W3C JSON соблюдаем ключевые правила формата:

- `$value` определяет token; token **не может** иметь вложенные tokens/groups (иначе ошибка).
- Groups могут иметь `$root` token; ссылки на группу без `.${root}` считаются ссылкой на group, а не token.
- `$type` наследуется от родительской группы, если не задан на токене.
- `$extends` применим только к group и **не** может ссылаться на token.
- Aliases/refs: поддерживаем curly brace `{path.to.token}` и `$ref` JSON Pointer как входные форматы (не ломая нашу модель semantic tokens).

**Оценка:** 9/10  
**Почему:** это снижает риск несовместимости и даёт предсказуемый импорт для multi-brand.

---

### 8.1.1) Color spaces v1 (P3/OKLCH): политика “без сюрпризов”

**Решение (зафиксировано):** v1 хранит и использует **sRGB** как единственный гарантированный runtime формат.

**Политика:**
- На вход импорта **можно принимать** P3/OKLCH как данные токенов.
- Но v1 **конвертирует в sRGB на этапе импорта (CLI)** и дальше работает только с sRGB значениями.

**Почему:** wide gamut поддержка в Flutter/платформах неоднородна; “магия в цветах” — плохой UX для DS‑библиотеки.

**Оценка:** 9/10

---

### 8.2) Semantic tokens v1: W3C-first + Hybrid (global semantic primitives + component tokens)

**Решение (зафиксировано):** используем **T1 + S3**:
- **W3C-first**: source of truth для токенов — W3C Design Tokens JSON.
- **Hybrid**:
  - **Global semantic primitives** (маленький whitelist, максимально стабильный API)
  - **Component tokens** (точные токены под компонент; по умолчанию ссылаются на global)

#### Структура файлов (концепт)

- `tokens/base.json`
  - `global/*` — global semantic primitives
  - `components/*` — component-scoped tokens (Button/Dropdown/…)
- `tokens/brands/<brand>.json`
  - `$extends` от `base` (group inheritance)
  - overrides: либо `global.*`, либо точечно `components.<x>.*`

#### W3C naming policy (чтобы `$extends` и refs работали предсказуемо)

- В W3C используем **group `$type` inheritance**, где уместно (например, `global.color.$type = "color"`).
- Ссылки/алиасы — через **curly brace** `{path.to.token}` (и допускаем `$ref` JSON Pointer на входе импорта).

#### Global semantic primitives v1 (минимальный whitelist)

Цель: дать базовый “язык дизайна”, но **не раздувать** global слой. Всё специфичное — в component tokens.

- `global.color.semantic.surface.canvas` (color)
- `global.color.semantic.surface.base` (color)
- `global.color.semantic.surface.raised` (color)
- `global.color.semantic.surface.overlay` (color)

- `global.color.semantic.text.primary` (color)
- `global.color.semantic.text.secondary` (color)
- `global.color.semantic.text.disabled` (color)
- `global.color.semantic.text.inverse` (color)

- `global.color.semantic.action.primaryBg` (color)
- `global.color.semantic.action.primaryFg` (color)

- `global.color.semantic.border.subtle` (color)
- `global.color.semantic.border.default` (color)
- `global.color.semantic.border.focus` (color)

- `global.color.semantic.status.dangerFg` (color)
- `global.color.semantic.status.dangerBg` (color)
- `global.color.semantic.status.successFg` (color)
- `global.color.semantic.status.successBg` (color)

- `global.dimension.semantic.tapTargetMin` (dimension) = **24px** (WCAG 2.2)
- `global.duration.semantic.motion.fast` (duration)
- `global.duration.semantic.motion.normal` (duration)

#### Component tokens v1: Button (пример “точности” без раздувания global)

`components.button.*` — это контракт для renderers кнопки. По умолчанию значения ссылаются на `global.*`.

- `components.button.minTapTarget` (dimension) = `{global.dimension.semantic.tapTargetMin}`
- `components.button.focusRing.color` (color) = `{global.color.semantic.border.focus}`

- `components.button.color.bg.default` (color) = `{global.color.semantic.surface.base}`
- `components.button.color.fg.default` (color) = `{global.color.semantic.text.primary}`
- `components.button.color.bg.primary` (color) = `{global.color.semantic.action.primaryBg}`
- `components.button.color.fg.primary` (color) = `{global.color.semantic.action.primaryFg}`
- `components.button.color.fg.disabled` (color) = `{global.color.semantic.text.disabled}`

*(остальные состояния/варианты добавляем аддитивно через component tokens; global слой не трогаем без крайней необходимости)*

**Важно (чтобы не раздувать global API):**
- Не заводим `action.primaryHover/Pressed` в глобальном слое.
- Hover/pressed/disabled и прочие “тонкие” состояния — это ответственность component tokens + renderer policy (state resolution + transforms).

**Оценка:** 9.5/10
**Почему:** максимальная совместимость с W3C `$extends`, минимальный риск разрастания global API, и предсказуемые overrides для брендов/компонентов.

#### Extension mechanism (OCP compliance)

**Проблема:** Hardcoded список semantic tokens нарушает Open/Closed Principle. Пользователи не могут добавить свои semantic tokens без изменения core.

**Решение (зафиксировано):** Extension через typed token definitions:

```dart
/// Базовый интерфейс для semantic token.
/// Позволяет определять custom tokens без изменения core.
abstract class SemanticToken<T> {
  /// Уникальное имя токена в namespace (e.g., "brand.accent")
  String get name;

  /// Разрешает значение токена из raw tokens.
  T resolve(RawTokens tokens);

  /// NOTE: Dart type erasure means `T` is not available at runtime.
  /// For type validation use explicit type checks in resolve() or
  /// rely on compile-time generics checking.
}

// Built-in semantic tokens:
class ActionPrimaryBg extends SemanticToken<Color> {
  @override
  String get name => 'global.color.semantic.action.primaryBg';

  @override
  Color resolve(RawTokens tokens) => tokens.colorRef('action.primary.500');
}

// User-defined extension:
class BrandAccent extends SemanticToken<Color> {
  @override
  String get name => 'brand.accent';

  @override
  Color resolve(RawTokens tokens) => tokens.colorRef('brand.accent.main');
}
```

**Регистрация custom tokens в теме:**
```dart
class MyBrandTheme extends RenderlessTheme {
  final Map<Type, SemanticToken> _customTokens = {
    BrandAccent: BrandAccent(),
    BrandSecondary: BrandSecondary(),
  };

  @override
  T? capability<T>() {
    // Check custom tokens first
    if (_customTokens.containsKey(T)) {
      return _customTokens[T] as T;
    }
    // Fallback to built-in capabilities
    return _builtInCapabilities[T] as T?;
  }
}
```

**Инварианты:**
- Built-in tokens = stable API, изменения только в major
- Custom tokens = пользователь контролирует, но отвечает за совместимость
- `$extends` в W3C JSON работает для обоих типов токенов

---

### 8.3) Animations v1: first-class (enter/exit) + overlay closing phase

**Решение (зафиксировано):**
- Анимации открытий/закрытий для overlay‑компонентов (`Dialog/Menu/Select`) считаем **частью контракта**, а не “визуальной детализацией”.
