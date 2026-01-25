## I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (part 3 — Алгоритмы/инварианты/тонкие моменты)

Back: [Index](./I31_autocomplete_sources_vnext.md)

### Цель этой части

Зафиксировать **точное поведение** источников, чтобы реализация была:

- предсказуемая,
- тестируемая,
- без гонок,
- и без “случайных UX решений”.

---

## 1) Модель состояний remote источника (MUST)

Remote часть живёт как маленькая state machine:

```text
idle ──(trigger load)──> loading ──(success)──> ready
  │                         │
  └────────(error)──────────┴──────> error

error ──(retry)──> loading
ready ──(new query)──> loading
```

Remote state хранит:

- `status`
- `queryText` (после применения query policy: trim + min length)
- `requestId` (монотонный int)
- `results` (последние успешные)
- `error` (стабильное, сериализуемое представление для UI)
- `lastCompletedRequestId` (для дебага и guardrails)

### Нормализация query (MUST)

`queryText` всегда вычисляется как:

1) `raw = controller.value.text`
2) если `trimWhitespace` → `raw.trim()` иначе `raw`
3) если `minQueryLength` не достигнут → remote должен быть в состоянии `idle` (см. ниже)

Важно: renderer должен опираться на `queryText`, а не на “сырой” текст.

### Важный guardrail: игнорируем устаревшие ответы

При старте загрузки:

- `requestId++`
- запоминаем текущий `requestId` локально
- `await load(...)`
- если `requestId` уже изменился → **игнорируем** результат

Это обязательная защита от гонок при быстром вводе.

---

## 2) Debounce (MUST) и его взаимодействие с IME/composing

### Почему debounce внутри компонента

Это поведение, которое должно быть одинаковым во всех местах.
Вынесение debounce наружу приводит к дублированию, разному UX и ошибкам с гонками.

### Правило debounce

- debounce применяется только для remote загрузок;
- local пересчитывается синхронно как сейчас.

### Тонкость: IME composing

Как в текущем `RAutocomplete` (v1.6):

- composing изменения **не должны**:
  - автоматически открывать меню,
  - сбрасывать dismissed,
  - триггерить remote load.

Иначе можно получить “меню всплыло само” после того, как пользователь его закрыл, просто потому что IME завершил composing.

Правило:

- если `TextEditingValue.composing` isValid && !isCollapsed:
  - **не стартуем** remote load
  - **не трогаем** dismissed
  - local можно пересчитать или нет — решение зависит от UX, но default: не пересчитывать (чтобы не мигало)

### Тонкость: “сброс ниже minQueryLength” не должен показывать stale remote

Если пользователь удалил текст и `queryText.length < minQueryLength`:

- remote статус становится `idle`
- remote results для UI считаются “неактуальными” и **не должны** отображаться

Иначе получится странно: “пустой запрос, но показываем remote результаты прошлой строки”.
Если хочется поведения “показывать прошлые remote результаты пока не введёшь снова” — это должно быть отдельной политикой (не default).

---

## 3) Триггеры remote загрузки

Remote policy:

- `loadOnInput` (default: true)
- `loadOnFocus` (default: false)

Trigger matrix:

| Событие | Local | Remote |
|---|---|---|
| focus gained | если openOnFocus и не dismissed — открыть меню | если policy.loadOnFocus && query ok && !composing — старт load |
| text changed | пересчитать options (если query ok) | если policy.loadOnInput && query ok && !composing — debounce+load |
| ArrowDown/ArrowUp | открыть меню и навигировать | старт load **только если меню открыто** или если UX разрешает “подсказки” |
| explicit tap | открыть меню | можно старт load как часть open (если query ok) |

Ключевой UX принцип:

remote не должен “дергать сеть” без причины. Поэтому default:

- `loadOnInput=true`, `loadOnFocus=false`

### Cache semantics (MUST минимум)

Remote cache policy нужен даже минимальный, потому что:

- пользователь часто флуктуирует между “ab” и “abc”
- без кэша вы получаете дрожание результатов и лишнюю нагрузку

Минимум vNext:

- `none`
- `lastSuccessfulPerQuery` (in-memory map, ограничение по размеру)

Ключ кэша: нормализованный `queryText`.

---

## 4) Hybrid: склейка local + remote в единый список

Внутри `AutocompleteCoordinator` появляется комбинирующий слой:

- `LocalSnapshot` → itemsLocal
- `RemoteSnapshot` → itemsRemote + remoteStateFeature
- `CombinedList` → itemsCombined (то, что уходит в меню renderer)

### 4.1) Dedupe

Если `combine.dedupeById == true`:

- строим `Map<ListboxItemId, HeadlessListItemModel>` отдельно для local и remote
- при коллизии используем `dedupePreference`:
  - preferLocal: remote item отбрасывается
  - preferRemote: local item отбрасывается

Важно: selection/checked state основываются на id, поэтому dedupe должен быть детерминированным.

### 4.1.1) Порядок списков (MUST)

Если `showSections == true`:

- порядок секций фиксированный: сначала local, потом remote

Если `showSections == false`:

- порядок по умолчанию: local items, затем remote items (после dedupe)

Иначе разные пресеты будут “случайно” показывать разные порядки, что ломает предсказуемость UX.

### 4.2) Sections (интуитивная разница)

Если `combine.showSections == true`, мы маркируем каждый item:

- `item.features.set(rAutocompleteItemSourceKey, local/remote)`
- `item.features.set(rAutocompleteSectionIdKey, <localSection>/<remoteSection>)`

Разделители/заголовки — concern preset’а.

Почему так:

- компонент не создаёт “header widgets”,
- но renderer может делать “group by sectionId” и рисовать заголовки.

### 4.3) Remote-only when local empty

Если `remoteOnlyWhenLocalEmpty == true`:

- пока local имеет items → remote items не показываем (но remote load может всё равно идти, если хочется)
- как только local пустой → отображаем remote.

Default: false (показываем оба).

---

## 5) “Loading / Error / Empty” без нового renderer контракта

Канон:

- “empty state” UI делается через `RDropdownButtonSlots.emptyState`
- а **причина empty** передаётся через request features:
  - `request.features.get(rAutocompleteRemoteStateKey)`

Рекомендованный mapping:

- `itemsCombined.isNotEmpty` → обычный список
- `itemsCombined.isEmpty`:
  - если remote.status == loading → “Идёт поиск…”
  - если remote.status == error → “Ошибка + Retry”
  - если query пустой → “Начните ввод”
  - если query ok, но нет результатов → “Ничего не найдено”

Важно: в hybrid “empty” может означать:

- local пуст, remote ещё не стартовал (minQueryLength)
- remote error
- remote loading
- оба источника пусты

Состояние должно быть однозначно выводимо из request features + query policy.

### Не-пустой список + remote loading (важно для hybrid UX)

Если local выдаёт items, а remote ещё грузится — “emptyState” не сработает.
Чтобы пользователь видел, что remote поиск идёт, canonical путь:

- preset использует `menuSurface` slot и читает `features`
- и, если `remote.status == loading`, добавляет небольшой индикатор (например, linear progress) поверх/под списком

Это не обязанность core компонента, но **должно быть поддержано contracts** (см. part 2: `features` в menuSurface context).

### Error shape (MUST)

В request features нельзя класть `Object/StackTrace`:

- это утечка implementation details в UI слой
- это сложно сериализовать/логировать

Поэтому вводим `RAutocompleteRemoteError`:

- `kind` (enum) + `message` (string)
- опционально `debugId` (строка) для корреляции с логами

---

## 6) Highlight/navigation при sectioned списке

Мы не вводим “заголовки как отдельные items” на уровне компонента (иначе ломаем listbox metas).

Значит highlight работает только по реальным option item’ам.

Инварианты:

- highlight skipping disabled как сейчас (`ListboxController`)
- при обновлении combined списка:
  - если прежний highlightedId всё ещё существует и enabled → сохранить
  - иначе → выбрать first enabled

Sections не влияют на навигацию.

---

## 7) Retry semantics

Retry — это команда, доступная только если `remote.status == error`.

В data/logic уровне retry:

- стартует load с тем же `queryText`, но новым `requestId`.

В UI retry предлагается preset’ом:

- кнопка/жест внутри `emptyState` slot
- вызывает `request.features.get(remoteState).commands.retry()`

Команды должны быть стабильно доступны и не замыкать `BuildContext`.

### Важная тонкость: где живут команды

Команды не должны быть частью “features map” как raw closures, если вы хотите:

- равенство/детерминизм request features,
- отсутствие лишних пересборок.

Рекомендуемый подход:

- `RAutocompleteRemoteState` — чистые данные
- `RAutocompleteRemoteCommands` — отдельный объект (interface), передаваемый через request features отдельным ключом
  - `retry()`
  - `clearError()` (опционально)

Но если вы оставляете commands внутри remoteState — тогда remoteState не должен участвовать в equality, либо должен быть `@immutable` без `==`.

---

## 8) DX guardrails (debug asserts)

В debug:

- если `remote.load` завершился с exception:
  - сохраняем `error` в remote state
  - не падаем (как принято в компонентах), но тестами фиксируем UX
- если `itemAdapter.id` нестабилен:
  - assert debugPrint как сейчас
- если `HeadlessItemFeatures.merge` встретил конфликт типов:
  - assert (это ошибка интеграции)

