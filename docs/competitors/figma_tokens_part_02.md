## Figma → Flutter Token Generators (part 2)

Back: [Index](./figma_tokens.md)

## Что можно взять для Headless

### 1. ITokens Interface Pattern (figma2flutter)
```dart
abstract interface class ColorTokens {
  Color get primary;
  Color get onPrimary;
  // ...
}
```

### 2. Context Extensions (design_tokens_builder)
```dart
extension TokensContext on BuildContext {
  AppTokens get tokens => Tokens.of(this);
}
```

### 3. Multi-theme из JSON
Можно добавить CLI который генерирует темы из Design Tokens JSON.

---

## Оценка для headless

| Критерий | Оценка |
|----------|:------:|
| Headless | 0 |
| Type-safety | 7 |
| Theming | 8 |
| Документация | 6 |
| Готовность | 7 |
| **Итого** | **5.6** |

Полезны только для генерации токенов, не для headless виджетов.
