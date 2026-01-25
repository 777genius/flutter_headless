## I33 — Switch Interaction Parity v1 (Material Ink ripple + Drag thumb like Flutter) (part 2)

## Тонкие моменты (обязательно учесть)

### 1) Не “писать ripple с нуля”
Мы используем Flutter ink:
- `InkResponse`/`InkWell`
- `ThemeData.splashFactory`
- `ListTileThemeData.shape` / `tileColor`/`selectedTileColor` (если нужно).

Наша задача — правильно расположить это архитектурно (через capability) и не создать второй путь активации.

### 2) Геометрия drag (без “компонент знает tokens”)
Компонент **не должен** зависеть от token resolver’ов, но drag зависит от размеров.
Поэтому:
- измеряем `track` и `thumb` через internal slot wrappers (см. B.6),
- padding rules фиксируем рядом с renderer (material/cup), чтобы получить 1:1.

### 3) Velocity / fling
Чтобы было 1:1, нужно:
- вытащить из Flutter исходников порог velocity (px/s) и логику выбора направления.
- учесть, что velocity sign в RTL инвертируется.

### 4) Семантика при `semanticLabel` и `title`
Для `RSwitchListTile`:
- если задан `semanticLabel`, компонент должен избегать дублирования семантики текста.
Рекомендация:
- `Semantics(label: semanticLabel, toggled: value, enabled: ...)` на root,
- `ExcludeSemantics` для `title/subtitle`, если `semanticLabel != null` (как защитный режим).

### 5) Не ломать slots
Slots должны “видеть”:
- `spec.value`,
- `state.dragT` (если добавим),
- иначе невозможно корректно кастомизировать thumb/track во время drag.

---

## Тесты (минимум, но покрывающий риски)

### 1) `RSwitch` (widget tests)
- Tap toggles once (Space/Enter/Tap) — уже есть в I32, не сломать.
- Drag updates visual progress:
  - старт → `dragT != null`,
  - update → `dragT` меняется монотонно,
  - end:
    - если `dragT` перешёл порог → `onChanged(true)`/`false`,
    - иначе возвращается назад (через анимацию к исходному bool).
- Fling:
  - при высокой скорости в сторону — переключение даже если `dragT` < 0.5 (если так в Flutter).
- RTL:
  - drag direction и результат корректны.
- Disabled:
  - drag/tap не вызывает `onChanged`,
  - `dragT` не меняется.

### 2) `RSwitchListTile` (widget tests)
- Tap on tile toggles once.
- Ripple surface is provided by capability:
  - в Material theme capability должен быть зарегистрирован,
  - в Cupertino — другой (без Ink).
Проверяем архитектурно (не “видимость ripple”), а наличие wrapper’а и отсутствие `ListTile.onTap`.
- Semantics:
  - `semanticLabel` влияет на root label,
  - нет дублирования семантики текста (smoke test).

### 3) Conformance report update
- Обновить evidence в `CONFORMANCE_REPORT.md` для:
  - drag,
  - ripple wrapper architecture.

---

## Команды (обязательно после правок)

```bash
melos run analyze
melos run test
```

## Порядок работ (рекомендуемый)

1) **Research**: выписать exact поведение Flutter:
   - пороги,
   - RTL,
   - что происходит при “частичном drag + release”.
2) Capability + primitives:
   - добавить `HeadlessPressableSurfaceFactory`,
   - material implementation на `InkResponse`,
   - cupertino implementation на opacity.
3) `RSwitchListTile`:
   - оборачивать renderer‑результат через capability,
   - обеспечить правильную семантику.
4) Drag state:
   - расширить contracts `RSwitchState`,
   - добавить drag logic в `RSwitch` (component),
   - добавить чистые функции геометрии в `logic/`.
5) Renderers:
   - ветка `if (dragT != null)` для thumb alignment,
   - lerp цветов/outline по dragT,
   - RTL.
6) Тесты + conformance обновление.

---

## Критерии готовности

- `RSwitchListTile` на Material preset даёт Ink ripple “как ListTile” (через InkResponse), при этом:
  - `ListTile.onTap == null` в renderer,
  - toggle идёт только через компонент.
- `RSwitch` и `RCupertinoSwitch` поддерживают drag:
  - thumb следует пальцу,
  - track/цвета реагируют во время drag,
  - корректно работает RTL,
  - корректно работает disabled,
  - нет двойных вызовов `onChanged`.
- Есть тесты на drag + RTL + disabled + tile tap, и обновлён conformance report.

