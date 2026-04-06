# Анализ конкурентов

## Обзор

| Пакет | Версия | Headless | Type-safe | Theming | Итого |
|-------|--------|:--------:|:---------:|:-------:|:-----:|
| [naked_ui](/guide/competitors/naked_ui) | 0.2.0-beta.7 | 10 | 7 | 2 | **6.3** |
| [Mix + Remix](/guide/competitors/mix) | 1.7.0 / 2.0-rc | 9 | 5 | 7 | **6.3** |
| [Forui](/guide/competitors/forui) | 0.17.0 | 4 | 6 | 9 | **7.2** |
| [shadcn_ui](/guide/competitors/shadcn_ui) | 0.43.0 | 3 | 6 | 7 | **6.2** |
| [shadcn_flutter](/guide/competitors/shadcn_flutter) | 0.0.47 | 3 | 6 | 6 | **5.6** |
| [theme_tailor](/guide/competitors/theme_tailor) | 3.1.2 | 0 | 8 | 8 | **6.4** |
| [styled_widget](/guide/competitors/styled_widget) | 0.4.1 | 2 | 4 | 2 | **3.8** |
| [Flutter Native](/guide/competitors/flutter_native) | 3.22+ | 5 | 7 | 7 | **7.6** |
| [Figma Tokens](/guide/competitors/figma_tokens) | - | 0 | 7 | 8 | **5.6** |

## По категориям

### Headless / Headless
1. **naked_ui** — Builder + state.when(), 12 компонентов
2. **Mix + Remix** — Utility-first DSL + headless widgets

### Готовые Design Systems
1. **Forui** — 40+ виджетов, CLI, минимализм
2. **shadcn_ui** — 30+ виджетов, shadcn стиль
3. **shadcn_flutter** — 84+ виджетов, standalone

### Styling / Theming
1. **Mix** — Utility-first DSL
2. **styled_widget** — Method chaining
3. **theme_tailor** — ThemeExtension codegen

### Нативные механизмы
1. **WidgetState** — Состояния виджетов
2. **ThemeExtension** — Кастомные токены
3. **InheritedWidget** — Передача данных

### Token Generation
1. **figma2flutter** — Tokens Studio → Flutter
2. **design_tokens_builder** — JSON → ThemeData
3. **style-dictionary-figma-flutter** — Style Dictionary

## Ключевые паттерны

### 1. Builder + state.when (naked_ui)
```dart
builder: (context, state, child) {
  final color = state.when(
    pressed: Colors.blue.shade900,
    hovered: Colors.blue.shade700,
    orElse: Colors.blue,
  );
  return Container(color: color);
}
```
✅ Удобно | ❌ Не exhaustive

### 2. Utility-first DSL (Mix)
```dart
Style(
  $box.color.ref($primary),
  $on.disabled($box.color(Colors.grey)),
)
```
✅ Компактно | ❌ Свой язык

### 3. WidgetStateProperty (Flutter)
```dart
WidgetStateProperty.resolveWith((states) {
  if (states.contains(WidgetState.pressed)) return value;
  return defaultValue;
})
```
✅ Нативный | ❌ Set-based

### 4. Method chaining (styled_widget)
```dart
Icon(Icons.home)
  .padding(all: 10)
  .backgroundColor(Colors.blue)
  .borderRadius(all: 8);
```
✅ Читаемо | ❌ Не headless

### 5. CLI генерация (Forui)
```bash
dart run forui theme create zinc-light
dart run forui style create button
```
✅ Scaffolding | ❌ Не flexible

## Свободная ниша

Никто не объединяет:
- ✅ Headless (naked_ui)
- ✅ Type-safe sealed classes (Dart 3.x)
- ✅ Zero-cost extension types (токены)
- ✅ Exhaustive pattern matching
- ✅ Multi-brand theming
- ✅ Нативный WidgetState

## Headless vs конкуренты

| Аспект | Конкуренты | Headless |
|--------|------------|------------|
| Headless | naked_ui только | ✅ Core feature |
| Варианты | String/enum | sealed class |
| Токены | Runtime | extension type |
| Состояния | Разные API | WidgetState |
| Exhaustive | ❌ | ✅ switch |
| Зависимости | 0-8 пакетов | 0 |
