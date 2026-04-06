## I23 (часть 5) — Пример Country select + порядок реализации + DoD

## Пример: Country select (флаг + имя + +код) в двух дизайнах (как будет писать приложение)

### Keys + adapter (DRY)

```dart
const countryIso2Key = HeadlessItemKey<String>(Symbol('country.iso2'));
const countryDialKey = HeadlessItemKey<String>(Symbol('country.dial'));

final countryItemAdapter = HeadlessItemAdapter.simple<Country>(
  id: (c) => ListboxItemId(c.iso2),
  titleText: (c) => c.name,
  subtitleText: (c) => '+${c.dialCode}',
  leadingEmoji: (c) => c.flagEmoji,
  semanticsLabel: (c) => '${c.name}, +${c.dialCode}',
  searchText: (c) => '${c.name} ${c.iso2} +${c.dialCode}',
  features: (c) => HeadlessItemFeatures.build((b) {
    b.set(countryIso2Key, c.iso2);
    b.set(countryDialKey, c.dialCode);
  }),
);
```

### Визуальный helper уровня приложения (пример)

```dart
Widget renderContent(HeadlessContent c) {
  return switch (c) {
    HeadlessTextContent(:final text) => Text(text),
    HeadlessEmojiContent(:final emoji) => Text(emoji),
    HeadlessIconContent(:final icon) => Icon(icon, size: 18),
  };
}
```

### Дизайн A (обычный)

```dart
RDropdownButton<Country>(
  items: countries,
  itemAdapter: countryItemAdapter,
  value: selected,
  onChanged: setSelected,
  placeholder: 'Страна',
  slots: RDropdownButtonSlots(
    anchor: Replace((ctx) {
      final item = ctx.selectedItem;
      final dial = item?.features.get(countryDialKey);
      return Row(
        children: [
          if (item?.leading != null) renderContent(item!.leading!),
          const SizedBox(width: 10),
          Expanded(child: Text(item?.primaryText ?? (ctx.spec.placeholder ?? ''))),
          const SizedBox(width: 10),
          if (dial != null) Text('+$dial'),
        ],
      );
    }),
    itemContent: Replace((ctx) {
      final item = ctx.item;
      final dial = item.features.get(countryDialKey);
      return Row(
        children: [
          if (item.leading != null) renderContent(item.leading!),
          const SizedBox(width: 10),
          Expanded(child: Text(item.primaryText)),
          const SizedBox(width: 10),
          if (dial != null) Text('+$dial'),
        ],
      );
    }),
  ),
);
```

### Дизайн B (компактный chip)

```dart
RDropdownButton<Country>(
  items: countries,
  itemAdapter: countryItemAdapter,
  value: selected,
  onChanged: setSelected,
  placeholder: 'Код',
  size: RDropdownSize.small,
  variant: RDropdownVariant.filled,
  overrides: RenderOverrides.only(
    const RDropdownOverrides.tokens(
      triggerBorderRadius: BorderRadius.all(Radius.circular(999)),
      itemMinHeight: 40,
      menuMaxHeight: 280,
    ),
  ),
  slots: RDropdownButtonSlots(
    anchor: Replace((ctx) {
      final item = ctx.selectedItem;
      final dial = item?.features.get(countryDialKey);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item?.leading != null) renderContent(item!.leading!),
          const SizedBox(width: 8),
          Text(dial != null ? '+$dial' : '—'),
        ],
      );
    }),
  ),
);
```

Важно: в обоих дизайнах нет индексов — все данные приходят из item‑модели и типизированных `features`.

---

## Порядок реализации (чтобы не раскатать всё одним гигантским PR)

1) `headless_foundation`:
   - добавить новые типы (content + features + model + adapter)
   - добавить `ListboxController.setMetas(List<ListboxItemMeta>)` (аддитивно)
   - экспортировать через публичные entrypoints (без `src/` импорта)

2) `headless_theme`:
   - обновить dropdown contracts (RenderRequest + Slots contexts) на `HeadlessListItemModel`
   - удалить `RDropdownItem`

3) `headless_material` / `headless_cupertino`:
   - адаптировать dropdown renderers под новую модель

4) `headless_dropdown_button`:
   - обновить public API (golden path + advanced options)
   - обновить mapping value↔id↔index
   - обновить render request composition

5) `headless_test`:
   - обновить dropdown conformance suites

6) `apps/example`:
   - добавить пример `CountrySelect` с двумя дизайнами

---

## Критерии готовности (DoD)

- [ ] В `headless_foundation` есть типизированная item‑модель + features + adapter без forced-null API.
- [ ] `RDropdownButton` больше не требует `label/index` как единственный путь для rich content.
- [ ] Slots получают item‑данные напрямую (без индексов).
- [ ] Material/Cupertino preset renderers компилируются и проходят тесты.
- [ ] Conformance suites обновлены и зелёные.
- [ ] Example app показывает “страны” в **двух дизайнах** на одном поведении.

