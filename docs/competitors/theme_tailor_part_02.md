## theme_tailor (part 2)

Back: [Index](./theme_tailor.md)

## Что можно взять

1. **Структура nested themes** — colors, typography, buttons
2. **Context extensions** — context.myTheme
3. **Encoder pattern** — для кастомных типов

## Сравнение с нашим подходом

| Аспект | theme_tailor | Headless |
|--------|--------------|------------|
| Headless | ❌ | ✅ |
| Токены | ✅ codegen | ✅ extension types |
| Виджеты | ❌ | ✅ |
| Варианты | ❌ | ✅ sealed |
| Build runner | ✅ нужен | ❌ не нужен |

## Комбинация с Headless

Можно использовать theme_tailor для генерации токенов,
а Headless для headless виджетов:

```dart
// theme_tailor для токенов
@TailorMixin()
class AppTokens extends ThemeExtension<AppTokens> with _$AppTokensTailorMixin {
  final Color primary;
  final double radiusMd;
  // ...
}

// Headless для виджетов с этими токенами
final theme = context.appTokens;
// Использовать в resolveButton()
```

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 0 |
| Type-safety | 8 |
| Theming | 8 |
| Документация | 7 |
| Готовность | 9 |
| **Итого** | **6.4** |
