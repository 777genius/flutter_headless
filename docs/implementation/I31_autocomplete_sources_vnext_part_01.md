## I31 — Autocomplete vNext: Local/Remote/Hybrid sources + RequestFeatures (part 1 — Public API и DX)

Back: [Index](./I31_autocomplete_sources_vnext.md)

### Зачем эта итерация

В текущем `RAutocomplete<T>` (см. `I24`, `I29`) есть сильная база поведения (overlay/focus/keyboard/multi-select), но отсутствует **канонический** способ:

- подключать **remote** источники (async), с гонками/дебаунсом/ошибками;
- одновременно использовать **local + remote** так, чтобы пользователю было **интуитивно** понятно, что где;
- не смешивать “данные/статус” с `RenderOverrides` (которые по смыслу про визуал/preset customization).

Цель vNext — сделать это **очевидным в API** и **стабильным в contracts**, даже если это breaking.

---

## Основные принципы (MUST)

1) **Source-first API**: вместо “одной функции optionsBuilder” — явная модель источника:
   - `local`
   - `remote`
   - `hybrid(local+remote)`

2) **Async поведение принадлежит компоненту**:
   - дебаунс, гонки, кэш, retry — это “поведение”, не “слой приложения”.

3) **UI не живёт в компоненте**:
   - компонент отдаёт renderer’у только данные + typed features.

4) **Никакого abuse `RenderOverrides` для статусов данных**:
   - `overrides` остаётся про визуальные токены/пер-экземпляр кастомизацию preset’а.

---

## Public API: `source:` вместо `optionsBuilder:` (breaking, intentional)

### Новый базовый виджет

```dart
RAutocomplete<T>(
  source: RAutocompleteSource<T>.local(
    options: (query) => ...,
  ),
  itemAdapter: ...,
  onSelected: ...,
)
```

Идентичный виджет поддерживает `multiple` режим как сейчас:

```dart
RAutocomplete<T>.multiple(
  source: ...,
  itemAdapter: ...,
  selectedValues: ...,
  onSelectionChanged: ...,
)
```

### Модель источников (без factory-магии и без `as` cast)

Важно: **не используем** `factory RAutocompleteSource.local(...)` возвращающий subtype, потому что:

- статический тип будет `RAutocompleteSource<T>`,
- и в hybrid-композиции вы неизбежно получите `as` cast или runtime проверки,
- что ухудшает DX и “очевидность”.

Поэтому делаем явные классы (просто и прозрачно):

```dart
sealed class RAutocompleteSource<T> {
  const RAutocompleteSource();
}

final class RAutocompleteLocalSource<T> extends RAutocompleteSource<T> {
  const RAutocompleteLocalSource({
    required this.options,
    this.policy = const RAutocompleteLocalPolicy(),
  });

  final Iterable<T> Function(TextEditingValue query) options;
  final RAutocompleteLocalPolicy policy;
}

final class RAutocompleteRemoteSource<T> extends RAutocompleteSource<T> {
  const RAutocompleteRemoteSource({
    required this.load,
    this.policy = const RAutocompleteRemotePolicy(),
  });

  final Future<Iterable<T>> Function(RAutocompleteRemoteQuery query) load;
  final RAutocompleteRemotePolicy policy;
}

final class RAutocompleteHybridSource<T> extends RAutocompleteSource<T> {
  const RAutocompleteHybridSource({
    required this.local,
    required this.remote,
    this.combine = const RAutocompleteCombinePolicy(),
  });

  final RAutocompleteLocalSource<T> local;
  final RAutocompleteRemoteSource<T> remote;
  final RAutocompleteCombinePolicy combine;
}
```

Ключевая идея: **hybrid композирует источники** и их policy, а не дублирует поля.

---

## Remote query shape (MUST, чтобы не протаскивать “сырой TextEditingValue”)

Remote загрузчику почти всегда нужны:

- нормализованный текст запроса,
- “сырой” текст (для дебага/telemetry),
- requestId (для корреляции),
- признак “почему мы загрузились” (input/focus/tap/keyboard) — чтобы можно было тонко оптимизировать backend.

```dart
enum RAutocompleteRemoteTrigger { input, focus, tap, keyboard }

@immutable
final class RAutocompleteRemoteQuery {
  const RAutocompleteRemoteQuery({
    required this.rawText,
    required this.text,
    required this.trigger,
    required this.requestId,
  });

  final String rawText;
  final String text;
  final RAutocompleteRemoteTrigger trigger;
  final int requestId;
}
```

---

## Политики: DRY без “лишних свойств”

### Remote policy (явная и расширяемая)

```dart
final class RAutocompleteRemotePolicy {
  const RAutocompleteRemotePolicy({
    this.query = const RAutocompleteQueryPolicy(),
    this.debounce = const Duration(milliseconds: 200),
    this.keepPreviousResultsWhileLoading = true,
    this.cache = const RAutocompleteRemoteCachePolicy.none(),
    this.loadOnFocus = false,
    this.loadOnInput = true,
  });

  final RAutocompleteQueryPolicy query;
  final Duration? debounce;
  final bool keepPreviousResultsWhileLoading;
  final RAutocompleteRemoteCachePolicy cache;
  final bool loadOnFocus;
  final bool loadOnInput;
}
```

`RAutocompleteQueryPolicy` — единый нейминг:

```dart
final class RAutocompleteQueryPolicy {
  const RAutocompleteQueryPolicy({
    this.minQueryLength = 0,
    this.trimWhitespace = true,
  });
  final int minQueryLength;
  final bool trimWhitespace;
}
```

Так не возникает `remoteMinChars` vs `minQueryLength`: везде одно.

### Remote cache policy (определить в API сразу, без “потом”)

```dart
sealed class RAutocompleteRemoteCachePolicy {
  const RAutocompleteRemoteCachePolicy();

  const factory RAutocompleteRemoteCachePolicy.none() =
      RAutocompleteRemoteCacheNone;

  const factory RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery({
    int maxEntries,
  }) = RAutocompleteRemoteCacheLastSuccessfulPerQuery;
}

final class RAutocompleteRemoteCacheNone extends RAutocompleteRemoteCachePolicy {
  const RAutocompleteRemoteCacheNone();
}

final class RAutocompleteRemoteCacheLastSuccessfulPerQuery
    extends RAutocompleteRemoteCachePolicy {
  const RAutocompleteRemoteCacheLastSuccessfulPerQuery({this.maxEntries = 32});
  final int maxEntries;
}
```

### Local policy (минимальный, без раздувания)

Local чаще всего “просто функция”. Но нам нужен небольшой policy для предсказуемости UX и совместимости с Remote:

```dart
final class RAutocompleteLocalPolicy {
  const RAutocompleteLocalPolicy({
    this.query = const RAutocompleteQueryPolicy(),
    this.cache = true,
  });
  final RAutocompleteQueryPolicy query;
  final bool cache;
}
```

Это не тащит “remote-only” свойства в local.

### Combine policy (только про склейку, SRP)

```dart
enum RAutocompleteDedupePreference { preferLocal, preferRemote }

final class RAutocompleteCombinePolicy {
  const RAutocompleteCombinePolicy({
    this.showSections = true,
    this.dedupeById = true,
    this.dedupePreference = RAutocompleteDedupePreference.preferLocal,
    this.remoteOnlyWhenLocalEmpty = false,
  });

  final bool showSections;
  final bool dedupeById;
  final RAutocompleteDedupePreference dedupePreference;
  final bool remoteOnlyWhenLocalEmpty;
}
```

---

## DX: “очевидно как использовать”

### 1) Local-only (синхронный режим)

```dart
RAutocomplete<Country>(
  source: RAutocompleteLocalSource(
    options: (q) => countries.where((c) => c.name.contains(q.text)),
  ),
  itemAdapter: countryAdapter,
  onSelected: (v) => setState(() => selected = v),
)
```

### 2) Remote-only (асинхронный режим)

```dart
RAutocomplete<User>(
  source: RAutocompleteRemoteSource(
    policy: const RAutocompleteRemotePolicy(
      query: RAutocompleteQueryPolicy(minQueryLength: 2),
      debounce: Duration(milliseconds: 250),
      keepPreviousResultsWhileLoading: true,
    ),
    load: (q) => api.searchUsers(q.text),
  ),
  itemAdapter: userAdapter,
  onSelected: selectUser,
)
```

### 3) Hybrid (local + remote, “интуитивная разница”)

```dart
RAutocomplete<Item>(
  source: RAutocompleteHybridSource(
    local: RAutocompleteLocalSource(
      options: (q) => recentItems.filter(q.text),
      policy: const RAutocompleteLocalPolicy(
        query: RAutocompleteQueryPolicy(minQueryLength: 0),
      ),
    ),
    remote: RAutocompleteRemoteSource(
      policy: const RAutocompleteRemotePolicy(
        query: RAutocompleteQueryPolicy(minQueryLength: 2),
      ),
      load: (q) => api.searchItems(q.text),
    ),
    combine: const RAutocompleteCombinePolicy(
      showSections: true,
      dedupeById: true,
      dedupePreference: RAutocompleteDedupePreference.preferLocal,
    ),
  ),
  itemAdapter: itemAdapter,
  onSelected: onPick,
)
```

UX difference достигается не “магией”, а тем, что:

- items маркируются как `source=local/remote` (через item features);
- меню может показывать секции (“Локально” / “В сети”);
- remote имеет явные состояния `loading/error/empty`.

---

## Non-goals (в рамках этой итерации)

- Стриминг результатов (incremental paging) — можно позже, поверх remote state.
- Глобальный кэш между виджетами — отдельно (в приложении), здесь только per-instance policy.
- Полная ARIA combobox модель — отдельная a11y итерация (в рамках текущих contracts).

---

## Guardrails для DX (чтобы не было “скрытой магии”)

- `RAutocompleteSource.remote(...)` не должен запускать запросы при `query.minQueryLength` не достигнутом.
- В hybrid режимах приоритеты (dedupe, порядок секций) определяются **только** `combinePolicy`, а не “как получилось”.
- Никаких требований к users code “делать debounce самому”.

