import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_phone_field/src/contracts/r_phone_field_types.dart';
import 'package:headless_phone_field/src/presentation/r_phone_field_slots_merger.dart';

void main() {
  const merger = RPhoneFieldSlotsMerger();

  test('prefix placement inserts spacing before editable text', () {
    final slots = merger.merge(
      baseSlots: null,
      countryButton: const Text('country'),
      placement: RPhoneFieldCountryButtonPlacement.prefix,
    );

    final prefix = slots.prefix;
    expect(prefix, isA<Padding>());
    final padding = prefix! as Padding;
    expect(
      padding.padding,
      const EdgeInsetsDirectional.only(end: 8),
    );
  });

  test('suffix placement inserts spacing after editable text', () {
    final slots = merger.merge(
      baseSlots: null,
      countryButton: const Text('country'),
      placement: RPhoneFieldCountryButtonPlacement.suffix,
    );

    final suffix = slots.suffix;
    expect(suffix, isA<Padding>());
    final padding = suffix! as Padding;
    expect(
      padding.padding,
      const EdgeInsetsDirectional.only(start: 8),
    );
  });

  test('leading placement inserts edge inset', () {
    final slots = merger.merge(
      baseSlots: const RTextFieldSlots(),
      countryButton: const Text('country'),
      placement: RPhoneFieldCountryButtonPlacement.leading,
    );

    expect(slots.leading, isA<Padding>());
    expect(slots.prefix, isNull);
    expect(slots.suffix, isNull);
  });

  test('trailing placement inserts edge inset', () {
    final slots = merger.merge(
      baseSlots: const RTextFieldSlots(),
      countryButton: const Text('country'),
      placement: RPhoneFieldCountryButtonPlacement.trailing,
    );

    expect(slots.trailing, isA<Padding>());
    expect(slots.prefix, isNull);
    expect(slots.suffix, isNull);
  });
}
