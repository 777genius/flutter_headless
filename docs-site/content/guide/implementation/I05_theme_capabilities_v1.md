## I05 — Theme v1: capability discovery + required capability failures

### Цель

Сделать “точку стыка” headless и визуала:
- компоненты не знают реализаций,
- capabilities маленькие (ISP),
- отсутствие нужного renderer’а падает **явно** и с понятным сообщением.

### Ссылки на требования

- Renderer contracts (0.1): `docs/V1_DECISIONS.md` → “0.1 Renderer contracts”
- Discovery/ISP: `docs/ARCHITECTURE.md` → “Renderer contracts: capability discovery…”
- Spec-first: `docs/SPEC_V1.md` → “Renderer capability discovery” + “явная диагностика”

### Что делаем

1) **Capability discovery контракт**
- `RenderlessTheme.capability<T>()` (уже есть skeleton)
- композиция capabilities (позже можно отдельным `RenderlessThemeComposition`)

2) **Required capability guard**
- утилита уровня theme: `requireCapability<T>(context)` или похожая
- сообщение ошибки должно говорить:
  - какая capability нужна,
  - как подключить (facade `headless` или свой theme composition)

Тонкие моменты:
- ошибка должна быть **предсказуемой**: один и тот же текст/формат, чтобы её легко находили в логах/issue.
- сообщение ошибки не должно “советовать магию” (например, не предлагать import конкретного renderer’а в компонент).
- для spec-first: в ошибке полезно указывать ссылку на `docs/SPEC_V1.md`/`docs/CONFORMANCE.md` (как “правильный путь”).

#### 2.1 Стандарт формата ошибки (MUST)

Чтобы экосистема была целостной (и чтобы issue/поиск работали), формат ошибки должен быть одинаковым во всех компонентах.

**MUST**: текст ошибки начинается с фиксированного префикса:

```text
[Headless] Missing required capability: <CapabilityType>
```

**MUST**: далее идут 4 строки (в таком же порядке):

```text
Component: <ComponentName>
How to fix: provide the capability via a HeadlessTheme (e.g. MaterialHeadlessTheme / CupertinoHeadlessTheme) or your own theme composition.
Spec: upstream docs/SPEC_V1.md
Conformance: upstream docs/CONFORMANCE.md
```

Примечания:
- `<CapabilityType>` — имя интерфейса capability (например `RButtonRenderer`).
- `<ComponentName>` — публичное имя компонента (например `RTextButton`, `RDropdownButton<T>`).
- ссылки — **upstream** (см. `docs/SPEC_V1.md` и `docs/CONFORMANCE.md` про внешние репозитории).

Тонкие моменты:
- не указывать “импортируй X renderer пакет” — компоненты не знают реализаций.
- не делать “мягкий fallback” внутри core: отсутствие capability должно быть **явной** ошибкой.

3) **Первый renderer контракт (для Button)**
- контракт интерфейса renderer’а
- render request включает:
  - spec/state
  - slots (если нужны)
  - (при необходимости) foundation types (через разрешённую зависимость `headless_contracts -> headless_foundation`)

Тонкие моменты:
- render request должен содержать только то, что действительно нужно renderer’у (perf + стабильность API).
- избегать “больших объектов”, которые пересоздаются на каждый build (см. `docs/ARCHITECTURE.md` → context splitting policy).

### Где живёт required-capability guard (важно)

**MUST**: guard живёт в theme/infra слое (например в `headless_theme`), а не копируется в каждый компонент.

Причины:
- единый формат ошибок (см. 2.1)
- единая политика “loud failure”
- меньше дублирования и риска расхождений

### Тесты (минимум, MUST)

- **T1**: запрос capability, которой нет → бросается ошибка со стандартным форматом (префикс + 4 строки).
- **T2**: запрос capability, которая есть → возвращается объект без лишней “магии”.

### Что НЕ делаем

- Не реализуем default renderers в core.
- Не делаем “монолитную тему” с десятками методов.

### Критерии готовности (DoD)

- Компонент может запросить capability, и если её нет — получает понятную диагностику.
- Renderer контракт не тянет реализацию (только интерфейс).

### Диагностика

- Если компоненты начинают проверять `if (theme is SomeTheme)` — это нарушение Discovery/ISP: возвращаемся и вводим capability composition.
- Если ошибки “разные” в разных компонентах — это нарушение стандарта 2.1 (должен быть один guard/один формат).

### Чеклист

- [x] capability discovery работает (generic type)
- [x] missing capability → явная ошибка с инструкцией
- [x] есть минимум 1 renderer контракт (Button) для vertical slice

