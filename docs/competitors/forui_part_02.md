## Forui (part 2)

Back: [Index](./forui.md)

## Что можно взять

1. **CLI генерация** — удобно для scaffolding
2. **FWidgetStateMap** — паттерн для состояний
3. **Структура FThemeData** — colors, typography, style
4. **Material interop** — toApproximateMaterialTheme()

## Сравнение с нашим подходом

| Аспект | Forui | Headless |
|--------|-------|------------|
| Headless | ❌ | ✅ |
| Готовые виджеты | ✅ 40+ | Примеры |
| CLI | ✅ | Можно добавить |
| Type-safe варианты | ❌ | ✅ |
| Multi-brand | ❌ | ✅ |
| Кастомизация | copyWith | Полная |

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 4 |
| Type-safety | 6 |
| Theming | 9 |
| Документация | 9 |
| Готовность | 8 |
| **Итого** | **7.2** |
