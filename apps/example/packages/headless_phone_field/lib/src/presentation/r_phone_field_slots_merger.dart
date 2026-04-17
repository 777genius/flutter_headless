import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../contracts/r_phone_field_types.dart';

final class RPhoneFieldSlotsMerger {
  const RPhoneFieldSlotsMerger();

  static const _inlineGap = 8.0;
  static const _edgeInset = 8.0;

  RTextFieldSlots merge({
    required RTextFieldSlots? baseSlots,
    required Widget countryButton,
    required RPhoneFieldCountryButtonPlacement placement,
  }) {
    return RTextFieldSlots(
      leading: switch (placement) {
        RPhoneFieldCountryButtonPlacement.leading =>
          _padStart(_join(countryButton, baseSlots?.leading), _edgeInset),
        _ => baseSlots?.leading,
      },
      trailing: switch (placement) {
        RPhoneFieldCountryButtonPlacement.trailing =>
          _padEnd(_join(baseSlots?.trailing, countryButton), _edgeInset),
        _ => baseSlots?.trailing,
      },
      prefix: switch (placement) {
        RPhoneFieldCountryButtonPlacement.prefix =>
          _padEnd(_join(countryButton, baseSlots?.prefix), _inlineGap),
        _ => baseSlots?.prefix,
      },
      suffix: switch (placement) {
        RPhoneFieldCountryButtonPlacement.suffix =>
          _padStart(_join(baseSlots?.suffix, countryButton), _inlineGap),
        _ => baseSlots?.suffix,
      },
    );
  }

  Widget? _join(Widget? first, Widget? second) {
    if (first == null) return second;
    if (second == null) return first;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        first,
        const SizedBox(width: 8),
        second,
      ],
    );
  }

  Widget? _padEnd(Widget? child, double paddingValue) {
    if (child == null) return null;
    return Padding(
      padding: EdgeInsetsDirectional.only(end: paddingValue),
      child: child,
    );
  }

  Widget? _padStart(Widget? child, double paddingValue) {
    if (child == null) return null;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: paddingValue),
      child: child,
    );
  }
}
