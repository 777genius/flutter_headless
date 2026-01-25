## theme_tailor (part 1)

Back: [Index](./theme_tailor.md)

# theme_tailor

**Code generator для ThemeExtension**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/theme_tailor](https://pub.dev/packages/theme_tailor) |
| **GitHub** | [github.com/Iteo/theme_tailor](https://github.com/Iteo/theme_tailor) |
| **Версия** | 3.1.2 |
| **Автор** | iteo.com |
| **Лицензия** | MIT |

## Концепция

> "Code generator for Flutter's ThemeExtension classes."

Автоматическая генерация boilerplate для ThemeExtension (copyWith, lerp, ==, hashCode).

## Проблема которую решает

Без генератора ThemeExtension требует много кода:

```dart
// Вручную — 50+ строк для простого класса
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color background;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppColors &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.background == background;
  }

  @override
  int get hashCode => Object.hash(primary, secondary, background);
}
```

## С theme_tailor

```dart
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@TailorMixin()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
  });

  final Color primary;
  final Color secondary;
  final Color background;
}
```

Генерирует:
- `copyWith()`
- `lerp()`
- `==` и `hashCode`
- Extension на `BuildContext` или `ThemeData`

## Установка

```yaml
dependencies:
  theme_tailor_annotation: ^3.0.1

dev_dependencies:
  build_runner: ^2.4.0
  theme_tailor: ^3.1.2
```

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Аннотации

### @TailorMixin — основная
```dart
@TailorMixin()
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeTailorMixin {
  // ...
}
```

### @TailorMixinComponent — без extensions
```dart
// Для вложенных тем, без context.myTheme
@TailorMixinComponent()
class ButtonColors extends ThemeExtension<ButtonColors>
    with _$ButtonColorsTailorMixin {
  // ...
}
```

### ThemeGetter options
```dart
@TailorMixin(themeGetter: ThemeGetter.none)      // Без extensions
@TailorMixin(themeGetter: ThemeGetter.onThemeData) // Theme.of(context).extension
@TailorMixin(themeGetter: ThemeGetter.onBuildContext) // context.myTheme
```

## Nested Themes

```dart
@TailorMixin()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeTailorMixin {
  const AppTheme({
    required this.colors,
    required this.typography,
    required this.buttons,
  });

  final AppColors colors;
  final AppTypography typography;
  final ButtonTheme buttons;
}

@TailorMixinComponent()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  const AppColors({required this.primary, required this.secondary});
  final Color primary;
  final Color secondary;
}

@TailorMixinComponent()
class AppTypography extends ThemeExtension<AppTypography>
    with _$AppTypographyTailorMixin {
  const AppTypography({required this.heading, required this.body});
  final TextStyle heading;
  final TextStyle body;
}
```

## Custom Encoders

Для типов которые не поддерживаются из коробки:

```dart
class DurationEncoder extends ThemeEncoder<Duration> {
  const DurationEncoder();

  @override
  Duration lerp(Duration a, Duration b, double t) {
    return Duration(
      milliseconds: lerpDouble(
        a.inMilliseconds.toDouble(),
        b.inMilliseconds.toDouble(),
        t,
      )!.round(),
    );
  }
}

@TailorMixin()
class AnimationTheme extends ThemeExtension<AnimationTheme>
    with _$AnimationThemeTailorMixin {
  const AnimationTheme({required this.duration});

  @themeEncoder
  static const durationEncoder = DurationEncoder();

  final Duration duration;
}
```

## JSON сериализация

```dart
@TailorMixin()
@JsonSerializable()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeTailorMixin {
  // ...

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      _$AppThemeFromJson(json);

  Map<String, dynamic> toJson() => _$AppThemeToJson(this);
}
```

## Использование

```dart
// Регистрация в теме
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [
      AppTheme(
        colors: AppColors(primary: Colors.blue, secondary: Colors.grey),
        typography: AppTypography(
          heading: TextStyle(fontSize: 24),
          body: TextStyle(fontSize: 16),
        ),
      ),
    ],
  ),
)

// Доступ (с ThemeGetter.onBuildContext)
final theme = context.appTheme;
final primary = theme.colors.primary;

// Или классически
final theme = Theme.of(context).extension<AppTheme>()!;
```

## theme_tailor_toolbox

Дополнительный пакет с готовыми энкодерами:

```dart
import 'package:theme_tailor_toolbox/theme_tailor_toolbox.dart';

// Готовые энкодеры
EncoderToolbox.color      // Color
EncoderToolbox.textStyle  // TextStyle
EncoderToolbox.duration   // Duration
// ...
```

## Плюсы

- ✅ **Убирает boilerplate** — 50 строк → 10 строк
- ✅ **Type-safe** — генерирует правильный код
- ✅ **Nested themes** — структурированные темы
- ✅ **Custom encoders** — расширяемость
- ✅ **JSON** — сериализация тем
- ✅ **Context extensions** — удобный доступ

## Минусы

- ❌ **Только токены** — не виджеты
- ❌ **Не headless**
- ❌ **Build runner** — дополнительный шаг
- ❌ **Нет вариантов** — primary/secondary руками

