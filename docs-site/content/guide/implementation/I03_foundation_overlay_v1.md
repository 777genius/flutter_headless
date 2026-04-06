## I03 — Foundation Overlay v1 (phase/close contract)

### Цель

Сделать overlay механизм “библиотечного уровня”, который:
- независим от Navigator/Route,
- даёт стабильный lifecycle для enter/exit (closing phase),
- обеспечивает корректный фокус/закрытие как механизм (не “магия” в компонентах).

### Ссылки на требования

- Overlay API v1: `docs/V1_DECISIONS.md` → “0.2 Overlay”
- Close contract: `docs/V1_DECISIONS.md` → “Close contract v1 — A1”
- Renderer phase API: `docs/V1_DECISIONS.md` → “Renderer phase API v1 — R1 + P2”
- Foundation границы: `docs/ARCHITECTURE.md` → “НЕ foundation” и “Overlay SLA / positioning”

---

### Минимальная модель (что обязательно есть в v1)

#### Жизненный цикл (phase) — допустимые переходы

Допустимы только монотонные переходы:

```text
opening -> open -> closing -> closed
opening -> closing -> closed   (race: close во время opening)
```

Запрещено:
- `closing -> open` (перевод назад)
- `closed -> open` без нового `show()` (нельзя “реанимировать” handle)

#### Базовые типы/контракты (public)

Минимум, который должен быть публичным в `headless_foundation`:
- `OverlayPhase` (enum)
- `OverlayHandle`:
  - `ValueListenable<OverlayPhase> phase`
  - `bool isOpen`
  - `void close()`
  - `void completeClose()`

Тонкий момент: **`close()` не удаляет subtree** — иначе exit анимации и a11y семантика ломаются.

### Что делаем (итеративно)

#### Шаг 1 — типы и минимальный handle (уже есть skeleton)
- `OverlayPhase` (opening/open/closing/closed)
- `OverlayHandle.phase` как `ValueListenable`
- `close()` переводит в `closing`, `completeClose()` завершает

Тонкие моменты (обязательные инварианты уже на этом шаге):
- `close()` **идемпотентен** (повторный вызов не ломает фазу).
- `completeClose()` **безопасен к повторным вызовам** (после `closed` — no-op).
- `close()` **не удаляет subtree** сразу (иначе exit-анимации и a11y ломаются).
- Переходы фаз **монотонны**: нельзя “откатываться” из `closing` в `open`.

#### Шаг 2 — AnchoredOverlayEngineHost + OverlayController (реальная механика)
- `AnchoredOverlayEngineHost` в дереве владеет слоями
- `OverlayController.show(...) -> OverlayHandle`
- stacking поддержан (минимум: список active overlays)

Тонкие моменты:
- “stacking” должен быть определён явно: последний открытый overlay — верхний слой (LIFO).
- handle ownership: кто открыл — тот держит handle и закрывает (без скрытых глобалей).
- если открыть overlay и тут же вызвать `close()` (race “opening → closing”) — система должна остаться консистентной.

Дополнительные тонкие моменты, которые обязательно учесть:
- show() **всегда** возвращает новый handle (старые handles не переиспользуются).
- если `close()` вызван, overlay остаётся интерактивно безопасным:
  - нельзя принимать новые “select/submit” действия, если компонент так решил (обычно блокируем в presentation).

#### Шаг 3 — dismiss/focus policies (MVP)
- outside tap / Esc как политики (не “захардкожено”)
- focus restore (POLA)

Тонкие моменты:
- outside tap не должен “протыкать” кликом в underlying UI, если overlay по политике должен закрыться (обычно нужен barrier/absorber).
- focus restore должен возвращать фокус туда, где он был до открытия (или по явной policy), иначе keyboard UX деградирует.

#### Шаг 4 — fail-safe timeout
- если renderer не вызвал `completeClose`, overlay обязан закрыться по таймауту и залогировать проблему (логгер пока может быть временным, но контракт обязателен)

Тонкие моменты:
- таймаут должен запускаться только в `closing` и отменяться/игнорироваться после `closed`.
- таймаут — это защита от утечек: нельзя “тихо” пропускать (должна быть диагностика).

### Что НЕ делаем

- Не строим полноценный positioning pipeline как Floating UI целиком (это будет расширение поверх MVP).
- Не делаем сложные nested scroll cases до первого компонента, который этого требует.

### Критерии готовности (DoD)

- Можно открыть overlay, перевести в `closing`, дождаться `completeClose()`, и overlay удаляется корректно.
- Есть fail-safe защита от вечного `closing`.
- Есть минимальные тесты поведения (не golden).

Минимальные тесты (обязательные):
- `close()` переводит в `closing` и не удаляет subtree немедленно.
- `completeClose()` переводит в `closed` и удаляет overlay.
- `close()`/`completeClose()` идемпотентны.
- fail-safe переводит в `closed`, если `completeClose` не вызван.

---

### Тест-матрица v1 (подробно)

Ниже — конкретные сценарии, которые **должны** быть покрыты тестами поведения (не golden).

#### T1 — Basic open/close

Шаги:
- show() → phase = opening
- (после монтирования) phase = open
- close() → phase = closing
- completeClose() → phase = closed

Ожидаемо:
- subtree не удалён до `closed`
- удалён строго при переходе в `closed`

#### T2 — Idempotency

Шаги:
- show()
- close() несколько раз подряд
- completeClose() несколько раз подряд

Ожидаемо:
- phase не “скачет”
- no throw
- повторные вызовы после `closed` — no-op

#### T3 — Race: close during opening

Шаги:
- show() (phase opening)
- сразу close()

Ожидаемо:
- phase становится closing (не обязательно успеть побывать в open)
- completeClose() переводит в closed

#### T4 — Fail-safe

Шаги:
- show() → close() (phase closing)
- НЕ вызывать completeClose
- дождаться таймаута

Ожидаемо:
- overlay уходит в `closed` автоматически
- есть диагностика (лог/сигнал), что renderer не вызвал completeClose

#### T5 — Stacking (LIFO)

Шаги:
- show(A) затем show(B)
- close(B) → completeClose(B)
- A остаётся активным/видимым (в зависимости от policy), затем close(A)

Ожидаемо:
- верхний слой закрывается первым
- закрытие верхнего не “ломает” нижний

#### T6 — Dismiss policies (минимум)

Шаги:
- show()
- emulation: Esc → close

Ожидаемо:
- close triggered
- фокус возвращается на trigger (если policy так задана)

---

### Диагностика/симптомы, что контракт нарушен

- Exit-анимации невозможно сделать: subtree исчезает сразу → `close()` удаляет subtree (ошибка).
- Overlay “зависает” в `closing` навсегда → нет fail-safe или completeClose не вызывается.
- Фокус “теряется” после закрытия → не реализован focus restore policy или он не детерминирован.

### Чеклист

- [x] Overlay API не зависит от Navigator/Route
- [x] `phase` observable и корректные переходы
- [x] `completeClose()` обязателен и есть fail-safe
- [x] Есть базовые dismiss/focus политики
- [x] Есть тесты на lifecycle

