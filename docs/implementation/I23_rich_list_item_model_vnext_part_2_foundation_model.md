## I23 (часть 2) — Foundation: инварианты + `HeadlessContent`/features/model

## Дизайн: новые типы в `headless_foundation/src/listbox/`

### Тонкие моменты (обязательные инварианты)

Это те места, где чаще всего “вроде работает”, но через месяц начинает дрейфовать поведение/типизация/UX.

#### 1) Стабильность `ListboxItemId` (иначе дрейф selection/highlight)

- `id` **MUST** быть стабильным для одного и того же логического айтема.
- `id` **MUST NOT** зависеть от позиции в списке, если список может сортироваться/фильтроваться.
- `id` **MUST** быть уникальным внутри списка в конкретный момент времени.

Если в списке окажутся два айтема с одинаковым `id`, то:
- `selectedIndex`/`highlightedIndex` становятся неоднозначными,
- typeahead может приводить к “не тому” айтему,
- и это невозможно “исправить” на уровне renderer.

Рекомендуемый guardrail: debug‑assert в компоненте при сборке списка items/options, что `ids` уникальны.

#### 2) Controlled/uncontrolled и синхронизация selection

Dropdown остаётся Flutter‑like:

- если `value` задан → controlled mode, selection источник истины снаружи
- если `value == null` и пользователь выбирает → компонент обязан вызвать `onChanged`, но не “присваивать себе value” без контракта

Тонкость: в controlled режиме компонент НЕ должен:
- оставлять `selectedId` на старом значении, если `value` поменялся извне,
- или “перетирать” внешний `value` внутренним состоянием.

В этой итерации:
- `selectedId` вычисляется из `value` через `itemAdapter.id(value)` на каждый build (cheap),
- `selectedIndex` — derived (поиск по `id`), без хранения как источника истины.

#### 3) Что делать, если `value` не найден в items

POLA‑поведение:
- если `value` задан, но `id` не найден в текущих `items` → считаем “ничего не выбрано” (selectedIndex = null)
- при открытии меню можно highlight:
  - либо first enabled (если selection отсутствует),
  - либо selected (если есть)

Это должно быть одинаково при любых renderer’ах.

#### 4) Typeahead нормализация (важно для “+7”, “ru”, пробелов)

`ListboxController` матчится по `typeaheadLabel.startsWith(query)`.
Чтобы страны/коды работали предсказуемо:

- `HeadlessItemAdapter` строит:
  - `typeaheadLabel = HeadlessTypeaheadLabel.normalize(searchText ?? primaryText)`
- `normalize(...)` **MUST** быть:
  - детерминированным,
  - не зависящим от `BuildContext`,
  - быстрым (O(n) по длине строки),
  - стабильным на всех платформах.

Рекомендуемая минимальная нормализация vNext:
- `trim()`
- заменить повторяющиеся пробелы на один пробел
- `toLowerCase()`

Опционально (если реально нужно для телефонов):
- удалить пробелы и дефисы из части с кодом,
- но важно: это должно быть единым правилом, не “как получилось в одном месте”.

#### 5) `HeadlessContent.title` vs `primaryText`

Renderer по умолчанию должен использовать `primaryText` (POLA), потому что:
- `title` может быть не текстом (emoji/icon),
- парсить `title` обратно в строку — плохая идея.

`title` нужен, чтобы слоты/кастомные renderer’ы могли собрать богатую строку, но `primaryText` остаётся стабильным “источником текста”.

#### 6) `HeadlessItemKey<T>` и типизация features

`HeadlessItemKey<T>` сравнивается по `id` (например, `Symbol`).
Значит:

- ключи объявляем `const` и переиспользуем,
- `debugName` — только диагностика,
- **MUST**: не переиспользовать один и тот же `id` для разных типов `T`.

Это осознанный дизайн, чтобы:
- не было runtime строковых ключей,
- типизация была жёсткой,
- и разные пакеты не конфликтовали случайно.

---

### 1) `HeadlessContent` (sealed, без Widget)

Цель: дать renderer/slots типизированный “контент”, не утягивая UI в foundation.

Минимум (vNext):

- `HeadlessContent.text(String)`
- `HeadlessContent.emoji(String)` (флаги стран)
- `HeadlessContent.icon(IconData)` (идентификатор; размер/цвет — в renderer)

Примечание по зависимостям:
- `IconData` лежит в Flutter (`package:flutter/widgets.dart`). Это приемлемо для `headless_foundation` (он и так Flutter‑пакет), но важно не тащить Material‑специфику (например `Icons.*`) в foundation.

Рекомендуемая реализация (чтобы `switch` был exhaustiveness-safe):

```dart
sealed class HeadlessContent {
  const HeadlessContent();
}

final class HeadlessTextContent extends HeadlessContent {
  const HeadlessTextContent(this.text);
  final String text;
}

final class HeadlessEmojiContent extends HeadlessContent {
  const HeadlessEmojiContent(this.emoji);
  final String emoji;
}

final class HeadlessIconContent extends HeadlessContent {
  const HeadlessIconContent(this.icon);
  final IconData icon;
}
```

Опционально позже (только при реальном спросе):
- `HeadlessContent.image(HeadlessImageRef)` где `HeadlessImageRef` sealed: `asset/network/memory`

Файл:
- `packages/headless_foundation/lib/src/listbox/headless_content.dart`

---

### 2) Типизированные features: `HeadlessItemKey<T>` + `HeadlessItemFeatures`

Цель: не плодить поля `dialCode/iso2/avatarUrl/...` в core контракте.

- `HeadlessItemKey<T>` — типизированный ключ (делаем `const`).
  - У ключа должен быть **стабильный идентификатор** (рекомендуемо: `Symbol id` с namespace, например `Symbol('app.country.dial')`).
  - `debugName` допускается только для диагностики, но не как “механизм поиска”.
- `HeadlessItemFeatures` — immutable bag:
  - `T? get<T>(HeadlessItemKey<T> key)`
  - builder `HeadlessItemFeatures.build((b) => b.set(key, value))`

Инварианты:
- типизация enforced: нельзя записать значение не своего типа;
- в public API не используем строковые ключи (строки допустимы только внутри `Symbol('...')` при объявлении ключа);
- `features` по умолчанию пустые (`HeadlessItemFeatures.empty`).

Рекомендуемый скелет API:

```dart
final class HeadlessItemKey<T> {
  const HeadlessItemKey(this.id, {this.debugName});

  final Symbol id;
  final String? debugName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HeadlessItemKey && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
```

`T` не участвует в равенстве ключа — ключ идентифицируется только через `id`.

#### `HeadlessItemFeatures`: внутренняя структура и безопасность типов

Рекомендованная реализация (type-safe с проверками):

- хранить данные как `Map<Symbol, Object>` (ключ = `HeadlessItemKey.id`)
- `get<T>(HeadlessItemKey<T> key)` делает приведение `as T?`
- в debug (assert) можно валидировать “один id — один тип” в пределах одного bag:
  - при `set(key, value)` если в map уже есть значение и оно не `is T`, то это ошибка использования API

Файл:
- `packages/headless_foundation/lib/src/listbox/headless_item_features.dart`

---

### 3) `HeadlessListItemModel`

Единая модель айтема для select/menu/listbox‑паттернов.

Рекомендуемая структура (минимально достаточная):

- **identity/behavior**:
  - `ListboxItemId id`
  - `bool isDisabled`
- **text/a11y/typeahead**:
  - `String primaryText` (канонический текст для UI fallback)
  - `String? semanticsLabel`
  - `String typeaheadLabel` (уже normalized; соответствует `ListboxItemMeta.typeaheadLabel`)
- **anatomy**:
  - `HeadlessContent? leading`
  - `HeadlessContent title` (по умолчанию `HeadlessContent.text(primaryText)`)
  - `HeadlessContent? subtitle`
  - `HeadlessContent? trailing`
- **extensions**:
  - `HeadlessItemFeatures features`

Guardrails:
- `primaryText` не пустой (assert).
- `typeaheadLabel` должен быть детерминированным и не зависеть от локали/темы/контекста (обычно `toLowerCase()` от searchText).
- `id` должен быть уникальным в списке (см. инварианты выше). В debug — assert в компоненте при сборке items/options.

Файл:
- `packages/headless_foundation/lib/src/listbox/headless_list_item_model.dart`

