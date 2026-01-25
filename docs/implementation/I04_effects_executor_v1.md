## I04 — Effects executor v1 (E1/A1)

### Цель

Сделать основу для стандарта E1:
- reducer остаётся pure,
- side-effects исполняются отдельно,
- async возвращается через result events (A1),
- есть дедуп/отмена/порядок (минимум на уровне контракта).

### Ссылки на требования

- E1: `docs/ARCHITECTURE.md` → “Единый стандарт поведения… (E1)”
- Async policy: `docs/ARCHITECTURE.md` → “Async в E1 (политика v1)”
- Contract 0.7: `docs/V1_DECISIONS.md` → “0.7 Effects Executor”

### Что делаем

1) **Типы эффектов**
- базовая категория effects (overlay/focus/announce/reposition и т.п.)
- ключ эффекта (для дедупа/коалесса)

Тонкие моменты:
- ключ должен быть **детерминированным** (иначе дедуп бессмысленен).
- эффекты должны быть “безопасны” к повторному запуску, если дедуп не сработал (defensive).

Рекомендуемая форма ключа (минимум):
- `category` + `targetId` (+ опционально `opId`)
  - пример: `overlay:close:<overlayId>`
  - пример: `focus:restore:<routeOrOverlayId>`

2) **Executor**
- API вида `execute(effects) -> dispatch(resultEvents)`
- коалесc в пределах кадра (если нужно)
- отмена по key/opId (минимальный механизм)

Тонкие моменты (самое важное):
- executor **не должен** синхронно дергать reducer напрямую (иначе легко получить рекурсию/циклы).
- result events должны диспатчиться через очередь (микротаска/пост-кадр) — важно для стабильности.
- если два effects конфликтуют (например, два reposition) — нужен key-based coalesce.

Политика доставки result events (рекомендуемая для v1):
- внутри одного `execute(...)`:
  - собираем tasks
  - исполняем side-effects
  - result events диспатчим **после** (микротаска или post-frame), чтобы не сломать call stack

Обработка ошибок:
- любой exception внутри эффекта должен приводить к `Failed` result event (а не silent ignore).

3) **Тесты**
- порядок исполнения (если зафиксирован)
- дедуп по key
- async → result event

Минимальный набор тестов (обязательный):
- дедуп по key: два одинаковых эффекта → реально исполняется один.
- cancel: отмена эффекта по key/opId не приводит к диспатчу “успешного” события.
- async: эффект завершился → пришёл `Succeeded/Failed` event.

---

### Тест-матрица v1 (подробно)

#### T1 — Dedupe within batch

Дано: `effects = [E(key=A), E(key=A)]`
Ожидаемо:
- исполнение E(A) ровно 1 раз
- result event(ы) ровно 1 набор для A

#### T2 — Coalesce (последний побеждает)

Дано: `effects = [Reposition(key=P, data=1), Reposition(key=P, data=2)]`
Ожидаемо:
- исполняется только data=2

#### T3 — Cancel before completion

Дано:
- запускаем async effect `Fetch(key=F, opId=1)`
- до завершения вызываем cancel(F, opId=1)

Ожидаемо:
- `Succeeded` не диспатчится
- (опционально) диспатчится `Cancelled` или ничего (но поведение должно быть фиксировано)

#### T4 — Error → Failed

Дано: effect кидает исключение
Ожидаемо:
- диспатчится `Failed` result event
- executor остаётся жив (не “падает навсегда”)

#### T5 — No synchronous reducer recursion

Дано: effect при выполнении вызывает dispatch result event
Ожидаемо:
- dispatch происходит не в том же call stack, что `execute(...)`
- нет рекурсивного вызова reducer

### Что НЕ делаем

- Не строим “универсальный runtime” на все случаи — только достаточный контракт для первых компонентов.

### Диагностика (тонкие баги, которые ловим рано)

- “дрожание” UI или бесконечные циклы:
  - почти всегда значит, что effect → result event → effect повторяется без дедупа/equality.
- порядок событий нестабилен:
  - значит result events диспатчатся синхронно и зависят от текущего call stack.

- эффекты “спамят” одно и то же действие каждый build:
  - значит нет key-based dedupe или нет стабильного equality состояния.

### Критерии готовности (DoD)

- Первый компонент может жить на E1: `reduce -> effects -> executor -> result events`.
- Есть тесты на поведение executor’а.

### Чеклист

- [x] Reducer остаётся pure (effects выносят side-effects)
- [x] Async идёт через effects → result events (EffectResult sealed class)
- [x] Есть минимум: key/dedupe/cancel (EffectKey + EffectExecutor)
- [x] Result events dispatch асинхронно (scheduleMicrotask)
- [x] Есть тесты T1-T5 (16 тестов)

