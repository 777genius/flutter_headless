## I00 — Bootstrap (monorepo skeleton)

### Цель

Подготовить репозиторий к реализации так, чтобы:
- структура совпадала с `docs/ARCHITECTURE.md` (monorepo tree),
- можно было запускать tooling единообразно,
- были минимальные "rails" для дальнейших итераций.

### Ссылки на требования

- Структура monorepo: `docs/ARCHITECTURE.md` → "Дерево папок (целевое)"
- Spec-first: `docs/ARCHITECTURE.md` → "Spec-first: Headless = стандарт…"
- `LLM.txt` policy: `docs/ARCHITECTURE.md` → "AI/MCP metadata policy (LLM.txt) — v1"

### Что делаем

1) **Корень репозитория**
- `melos.yaml`
- корневой `pubspec.yaml` (workspace/tooling only)
- `analysis_options.yaml`
- `.gitignore`

2) **Базовые команды разработчика (локально)**

Минимальный набор, который должен работать всегда:

```bash
dart pub get
dart run melos bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
```

3) **Пакеты (скелеты) по целевому дереву**

Core:
- `packages/headless_tokens`
- `packages/headless_foundation`
- `packages/headless_contracts`
- `packages/headless_theme`

Опциональные/вокруг core:
- `packages/headless_test`
- `packages/headless` (facade)

Компоненты-скелеты:
- `packages/components/headless_button`
- `packages/components/headless_dropdown_button`
- `packages/components/headless_dialog` (удалён из репо)

Tooling/app:
- `tools/headless_cli`
- `apps/example`

4) **Минимальные smoke-тесты (обязательно)**

Причина: и `dart test`, и `flutter test` падают ошибкой, если в пакете нет `test/` директории и не переданы файлы тестов.
Чтобы фундамент всегда стартовал "зелёным", добавляем по 1 smoke‑тесту на пакет.

#### Какие пакеты используют какой test runner

| Пакет | Test runner | Причина |
|-------|-------------|---------|
| `headless_tokens` | `dart test` | Pure Dart, без Flutter |
| `tools/headless_cli` | `dart test` | Pure Dart CLI |
| Все остальные | `flutter test` | Зависят от Flutter SDK |

#### Паттерн smoke-теста (важно!)

Smoke-тесты **не должны требовать публичных символов** — только проверка "import compiles". Иначе можно случайно "застолбить" API раньше времени.

**Правильно:**
```dart
import 'package:flutter_test/flutter_test.dart';
// ignore: unused_import
import 'package:headless_button/headless_button.dart';

void main() {
  test('smoke', () {
    // Smoke-test: import must compile.
    expect(true, isTrue);
  });
}
```

**Неправильно:**
```dart
// ❌ Требует публичный символ — застолбит API!
expect(headless_button, isNotNull);
```

Требования:
- В каждом **pure Dart** пакете: `test/smoke_test.dart` + `dev_dependency: test`.
- В каждом **Flutter** пакете: `test/smoke_test.dart` + `dev_dependency: flutter_test`.
- Smoke‑тесты гарантируют только:
  - что пакет импортируется,
  - что `melos run test` не "красный" на пустом скелете.

5) **LLM metadata**
- `LLM.txt` для каждого publishable package (минимум: Purpose/Non-goals/Invariants/Usage/Anti-patterns).

6) **Публикация на pub.dev — осознанно отложена**

Все пакеты содержат `publish_to: none`. Это **осознанное решение**:
- Публикация на pub.dev — отдельная итерация (не смешиваем с bootstrap).
- Не "чинить" pubspec раньше времени.
- Когда будем готовы к публикации — будет явная итерация с версионированием, changelog, etc.

### Артефакты итерации (что должно появиться в git)

- `melos.yaml`
- `pubspec.yaml` (workspace)
- `analysis_options.yaml`
- `.gitignore`
- каталоги `packages/`, `apps/`, `tools/` с `pubspec.yaml` в каждом publishable package
- `LLM.txt` в каждом publishable package
- `test/smoke_test.dart` в каждом пакете (Dart/Flutter)

### Что НЕ делаем

- Не реализуем реальные контракты (кроме минимального компилируемого каркаса).
- Не добавляем UI baseline в core.
- Не тянем зависимости "на будущее" (YAGNI).
- Не публикуем на pub.dev (это отдельная итерация).

### Тонкие моменты (частые ошибки)

- **Mixed Dart/Flutter монорепо**: нельзя считать, что `dart test` пройдёт во Flutter пакете. Melos scripts **обязаны** учитывать `flutter: true/false` через `packageFilters`.

- **Flutter startup lock (критично!)**: `flutter test` плохо переносит параллельный запуск во множестве пакетов и может зависать на "startup lock".
  - **Правило bootstrap**: Flutter тесты **всегда sequential** (`--concurrency=1`).
  - Не "оптимизировать" параллельность — снова поймаешь startup lock.
  - В `melos.yaml` это зафиксировано:
    ```yaml
    test:flutter:
      run: melos exec --fail-fast --concurrency=1 -- "flutter test"
      packageFilters:
        flutter: true
    ```

- **Facade зависимости**: `packages/headless` может зависеть от компонентов, но **никто не должен зависеть от facade** (см. `docs/ARCHITECTURE.md` dependency matrix).

- **`publish_to: none`**: это осознанно, публикация — отдельная итерация.

### Критерии готовности (Definition of Done)

**Pass criteria = все команды зелёные:**

```bash
dart run melos bootstrap        # 12 packages bootstrapped
dart run melos run analyze      # 0 errors, 0 warnings
dart run melos run test         # All tests passed
dart run melos run format       # No formatting issues (optional)
```

Дополнительно:
- Структура репо соответствует `docs/ARCHITECTURE.md`.
- В каждом publishable package есть `LLM.txt`.

### Диагностика (если не проходит)

- `melos bootstrap` не видит пакет:
  - проверь, что в пакете есть `pubspec.yaml`,
  - проверь, что путь попадает под `packages/**`, `apps/**`, `tools/**`.
- `melos test` падает:
  - убедись, что для Flutter пакетов используется `flutter test`, а для pure Dart — `dart test`.
  - если висит "startup lock" — проверь `--concurrency=1` для Flutter тестов.
- Smoke-тест требует публичный символ:
  - заменить на паттерн `expect(true, isTrue)` + `// ignore: unused_import`.

### Чеклист

- [x] Корневой tooling (melos + pubspec + analysis) добавлен
- [x] Все пакеты-скелеты созданы по дереву из `docs/ARCHITECTURE.md`
- [x] `LLM.txt` добавлен во все publishable packages
- [x] `apps/example` компилируется (минимальный `main.dart`)
- [x] Smoke-тесты используют паттерн "import compiles" (без публичных символов)
- [x] Flutter тесты sequential (`--concurrency=1`)
- [x] `publish_to: none` во всех пакетах (pub.dev — отдельная итерация)
