## I27 — DX v1.4: Error policy (no release crash) + guardrails for custom renderers

### Контекст / проблема

Есть две реальные проблемы DX, которые будут раздражать часть Flutter‑сообщества:

1) **Missing theme/capability приводили к runtime exception** (и могли падать в release), что воспринимается как “слишком хрупко”.
2) **Кастомные renderer’ы легко ломают close contract** (забыли `completeClose()` → overlay висит в `closing`, либо закрывается по fail‑safe и даёт странные эффекты).

Параллельно есть коммуникационная проблема:
3) В user‑facing документации слишком много DDD/SOLID терминов — это отпугивает “практиков”, даже если код и тесты сильные.

Эта итерация фиксирует (1) как поведение в коде, а (2) и (3) — как UX‑документы и guardrails.

---

### Цели итерации

- **Не падать в release**, если пользователь забыл `HeadlessThemeProvider` или не подключил нужный renderer capability.
- Сохранить “fail‑fast” в debug, чтобы ошибки находились сразу во время разработки.
- Дать ясные правила для кастомных renderer’ов (особенно для overlay close contract).
- Упростить “happy path” в документации: меньше концептов, больше copy‑paste.

---

### Решение: error policy (v1.4)

#### 1) Безопасный lookup capability

Добавляем `HeadlessThemeProvider.maybeCapabilityOf<T>(...)`:

- **Debug**: бросает стандартную ошибку через `assert(() { throw ... }())` (быстро и предсказуемо).
- **Release**: возвращает `null`.

#### 2) Компоненты в release не падают

Компоненты (`RTextButton`, `RDropdownButton`, `RTextField`, `RCheckbox`, `RCheckboxListTile`, `RAutocomplete`) вместо `capabilityOf` используют `maybeCapabilityOf`.

Если `null`:
- вызываем `FlutterError.reportError(...)` (чтобы было видно в логах/Crashlytics),
- рендерим минимальный `HeadlessMissingCapabilityWidget` (без Material/Cupertino зависимостей).

Важно: это **не baseline UI**. Это диагностический placeholder на “неправильной конфигурации”.

---

### Guardrails для overlay close contract (custom renderers)

#### Инвариант (обязательный)

Если renderer запускает exit‑анимацию для overlay‑контента:

- `close()` переводит overlay в `closing` и **контент должен остаться в дереве**.
- После завершения exit‑анимации renderer **обязан вызвать** `OverlayHandle.completeClose()`.

#### Fail‑safe (страховка)

В `OverlayHandleImpl` есть fail‑safe таймер: если `completeClose()` не вызван, overlay будет принудительно закрыт.

- По умолчанию `OverlayController` пишет диагностическое сообщение в `debugPrint`.
- Если приложению нужно “сделать громче” (например, в staging), оно может передать собственный `onFailSafeTimeout` в `OverlayController`.

#### Рекомендуемый паттерн (обязательный для анимированных overlay)

Используйте `CloseContractRunner`:

- at‑most‑once `completeClose()`
- отмена close при reopen
- корректное завершение при `dispose()`

Пример есть в `headless_material` (dropdown menu close contract).

---

### Что делать с DDD/SOLID лексикой (док‑стратегия)

Решение: разделить “кому что читать”.

- **Users docs** (практический уровень): “как подключить”, “как кастомизировать”, “как дебажить”.
  - Минимум терминов DDD/SOLID.
  - Ставка на рецепты: copy‑paste примеры, таблицы “если видишь X — делай Y”.
- **Contributors / Implementation docs**: там DDD/SOLID допустимы, но только когда это реально помогает поддерживать границы и инварианты.

Эта папка (`docs/implementation/`) остаётся инженерной, но в ближайшем шаге стоит вынести “Happy path cookbook” в `docs/users/`.

---

### Критерии готовности

- [x] Компоненты больше не обязаны падать в release при missing theme/capability.
- [x] В debug ошибки остаются быстрыми и читаемыми.
- [x] Добавлен публичный diagnostic fallback (`HeadlessMissingCapabilityWidget`).
- [x] Описаны инварианты и рекомендуемый паттерн для `completeClose()`.
- [x] Все тесты monorepo зелёные (`melos run test`).

