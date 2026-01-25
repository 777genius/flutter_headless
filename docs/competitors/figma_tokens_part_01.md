## Figma → Flutter Token Generators (part 1)

Back: [Index](./figma_tokens.md)

# Figma → Flutter Token Generators

**Инструменты для генерации Flutter кода из Figma Design Tokens**

## Обзор инструментов

| Инструмент | Подход | Активность |
|------------|--------|------------|
| style-dictionary-figma-flutter | Style Dictionary transform | Средняя |
| design_tokens_builder | BuildRunner + JSON | Активный |
| figma2flutter | Tokens Studio JSON | Активный |
| Figma Puller | Прямой pull из Figma | Новый |

---

## style-dictionary-figma-flutter

### Информация
- **GitHub**: [github.com/aloisdeniel/style-dictionary-figma-flutter](https://github.com/aloisdeniel/style-dictionary-figma-flutter)
- **npm**: style-dictionary-figma-flutter

### Концепция

Расширение для [Style Dictionary](https://amzn.github.io/style-dictionary/) которое генерирует Flutter код из JSON токенов экспортированных из Figma.

### Поддерживаемые типы

- Colors
- TextStyles
- BorderRadius
- EdgeInsets (padding/margin)
- Sizes
- Breakpoints
- Icons

### Workflow

```
Figma → Design Tokens Plugin → JSON → Style Dictionary → Flutter
```

### Конфиг

```json
{
  "source": ["tokens/**/*.json"],
  "platforms": {
    "flutter": {
      "transformGroup": "flutter",
      "buildPath": "lib/theme/",
      "files": [
        {
          "destination": "colors.dart",
          "format": "flutter/colors"
        },
        {
          "destination": "typography.dart",
          "format": "flutter/textStyles"
        }
      ]
    }
  }
}
```

### Генерируемый код

```dart
// colors.dart
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  // ...
}

// typography.dart
class AppTypography {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  // ...
}
```

---

## design_tokens_builder (simpleclub)

### Информация
- **GitHub**: [github.com/simpleclub/design_tokens_builder](https://github.com/simpleclub/design_tokens_builder)
- **pub.dev**: design_tokens_builder

### Концепция

BuildRunner пакет который генерирует Flutter ThemeData из Design Tokens JSON (совместим с Figma Tokens плагином).

### Особенность

Генерирует **Material 3 ThemeData**, а не кастомные классы.

### Workflow

```
Figma → Tokens Studio Plugin → JSON → BuildRunner → ThemeData
```

### Структура токенов

```json
{
  "colors": {
    "primary": {
      "value": "#6366F1",
      "type": "color"
    },
    "secondary": {
      "value": "#64748B",
      "type": "color"
    }
  },
  "spacing": {
    "sm": {
      "value": "8",
      "type": "spacing"
    }
  }
}
```

### Генерация

```bash
flutter pub run build_runner build
```

### Результат

```dart
// Генерирует ThemeData с:
// - ColorScheme
// - TextTheme
// - ThemeExtensions для кастомных токенов

final lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF64748B),
  ),
  extensions: [
    CustomSpacing(sm: 8, md: 16, lg: 24),
  ],
);
```

### Context Extensions

```dart
// Автоматически генерирует shortcuts
context.colorScheme.primary
context.textTheme.headlineLarge
context.customSpacing.md
```

---

## figma2flutter

### Информация
- **pub.dev**: [pub.dev/packages/figma2flutter](https://pub.dev/packages/figma2flutter)

### Концепция

Конвертирует Tokens Studio JSON exports в Flutter код.

### Уникальные фичи

- **Multi-theme support** — несколько тем из одного файла
- **ITokens interface** — контракт для тем
- **InheritedWidget** — Tokens provider
- **Composition tokens** — поддержка сложных токенов
- **Free & Open Source**

### Поддерживаемые токены

- Color
- Typography / TextStyle
- Spacing
- BorderRadius
- BoxShadow
- Opacity
- Sizing
- Border
- Composition (комбинации)

### Генерируемая структура

```dart
// Интерфейс
abstract class ITokens {
  Color get colorPrimary;
  TextStyle get typographyHeading;
  double get spacingMd;
  // ...
}

// Реализация темы
class LightTokens implements ITokens {
  @override
  Color get colorPrimary => Color(0xFF6366F1);
  // ...
}

class DarkTokens implements ITokens {
  @override
  Color get colorPrimary => Color(0xFF818CF8);
  // ...
}

// InheritedWidget
class Tokens extends InheritedWidget {
  final ITokens data;
  // ...
  static ITokens of(BuildContext context) => ...
}
```

### Использование

```dart
// Провайдер
Tokens(
  data: LightTokens(),
  child: MyApp(),
)

// Доступ
final primary = Tokens.of(context).colorPrimary;
```

---

## Figma Puller

### Информация
- **Medium**: [статья автора](https://medium.com/@ducduy.dev/figma-puller-bring-your-figma-design-tokens-directly-into-flutter-0392d25cd63f)

### Концепция

Прямой pull токенов и ассетов из Figma API без экспорта JSON.

### Возможности

- Pull design tokens напрямую из Figma
- Генерация Dart кода
- Автоматический экспорт иконок/изображений
- CLI инструмент

---

## Сравнение

| | style-dictionary | design_tokens_builder | figma2flutter |
|---|---|---|---|
| Input | JSON | JSON | JSON |
| Output | Static classes | ThemeData | ITokens + InheritedWidget |
| Multi-theme | ❌ | ✅ | ✅ |
| Material 3 | ❌ | ✅ | ❌ |
| Build runner | ❌ npm | ✅ | ✅ |
| Composition tokens | ❌ | Partial | ✅ |

---

