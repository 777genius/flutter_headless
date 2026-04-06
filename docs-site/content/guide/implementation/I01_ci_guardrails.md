## I01 — CI guardrails (DAG + domain purity + format/analyze/test)

### Цель

Сделать так, чтобы архитектуру было **сложно сломать случайно**:
- domain слой не тащит Flutter,
- нет циклов зависимостей (DAG),
- формат/анализ/тесты запускаются одинаково локально и в CI.

### Ссылки на требования

- Domain purity: `docs/ARCHITECTURE.md` → “Где нельзя хранить состояние… / CI проверка (локально)”
- DAG: `docs/ARCHITECTURE.md` → “Запрет циклов (обязательное правило)”
- SemVer/lockstep: `docs/ARCHITECTURE.md` → “Политика версионирования…”
- Conformance mindset: `docs/CONFORMANCE.md`

### Что делаем

1) **CI workflow**
- Добавить `.github/workflows/ci.yml`.
- Минимальные jobs:
  - format check
  - analyze
  - test
  - architecture checks:
    - domain purity (`grep package:flutter` в `*/lib/src/domain/`)
    - circular deps (через `dart pub deps --no-dev` по пакетам)
    - public API discipline:
      - запрет `package:<pkg>/src/...` в кросс‑пакетных import/export
      - запрет кросс‑пакетных import/export не через entrypoint `package:<pkg>/<pkg>.dart`
      - запрет прямого `export 'src/...'` из `lib/<pkg>.dart`

2) **Melos scripts**

Важно: в монорепо будут и Dart, и Flutter пакеты.
- Для Flutter пакетов тест-команда должна быть `flutter test`.
- Для pure Dart пакетов — `dart test`.

Решение: завести melos scripts, которые различают пакеты по `flutter: true/false`.

Рекомендуемый минимум (должен быть одинаковым локально и в CI):

```bash
dart pub get
dart run melos bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
```

3) **Документировать как запускать локально**
- Короткий блок в README или отдельный `docs/implementation/` раздел.

### Тонкие моменты (в которых обычно ломают архитектуру)

- **DAG проверка**:
  - `dart pub deps --no-dev` ловит “circular” только если зависимости реально подтянуты. Поэтому CI должен делать `melos bootstrap` до проверок.
- **Domain purity**:
  - проверяем не только `packages/*/lib/src/domain/`, но и `packages/components/*/lib/src/domain/`.
  - проверка должна падать, даже если импорт Flutter появился в одном файле (не “warning”).
- **Flutter vs Dart тесты**:
  - `dart test` не должен запускаться в Flutter пакетах.
  - `flutter test` не должен запускаться в pure Dart пакетах.

### Диагностика (как быстро понять, что сломалось)

- CI упал на domain purity:
  - искать в выводе конкретный файл/пакет,
  - переносить Flutter-тип/логику в `presentation/` или в foundation механизмы.
- CI упал на circular deps:
  - временно прогнать `dart pub deps --no-dev` внутри проблемного пакета,
  - устранить обратную зависимость (обычно: компонент → компонент или theme/foundation перепутаны местами).

### Что НЕ делаем

- Не пытаемся сделать “идеальный CI” (кэширование, матрицы OS) до появления первых тестов/кода.
- Не добавляем golden-first подход (см. `docs/MUST.md` про “поведение + a11y”).

### Критерии готовности (DoD)

- CI проходит на пустых/скелетных пакетах.
- Архитектурные проверки реально “падают”, если нарушить правила (быстрая ручная проверка).

### Критерии готовности (Pass criteria)

```bash
# CI workflow существует и содержит все шаги
ls .github/workflows/ci.yml

# Локальные команды работают
dart run melos bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
```

### Чеклист

- [x] `.github/workflows/ci.yml` добавлен
- [x] Есть шаги: format/analyze/test
- [x] Есть шаги: domain purity + DAG/circular deps
- [x] Circular deps проверяется по всем пакетам (через `melos list --parsable`)
- [x] Есть понятная инструкция локального запуска (README → Development)

