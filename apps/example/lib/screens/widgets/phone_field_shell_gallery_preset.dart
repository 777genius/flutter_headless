import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

final _softValue = PhoneNumber.parse('+12025550148');
final _minimalValue = PhoneNumber.parse('+33142685300');
final _travelValue = PhoneNumber.parse('+447911123456');
final _consoleValue = PhoneNumber.parse('+380671234567');

enum PhoneFieldShellPreset { soft, minimal, travel, console }

double phoneFieldShellCardWidth(double maxWidth) {
  if (maxWidth < 1080) return maxWidth;
  return (maxWidth - 16) / 2;
}

String phoneFieldShellTitle(PhoneFieldShellPreset preset) => switch (preset) {
      PhoneFieldShellPreset.soft => 'Soft Checkout',
      PhoneFieldShellPreset.minimal => 'Editorial Minimal',
      PhoneFieldShellPreset.travel => 'Travel Concierge',
      PhoneFieldShellPreset.console => 'Ops Console',
    };

String phoneFieldShellDescription(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => 'Commerce pill with an inline chip.',
      PhoneFieldShellPreset.minimal => 'Sparse line with a trailing selector.',
      PhoneFieldShellPreset.travel => 'Travel field with a segmented trigger.',
      PhoneFieldShellPreset.console => 'Operational shell with a hard badge.',
    };

String phoneFieldShellFieldCaption(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => 'Priority callback',
      PhoneFieldShellPreset.minimal => 'Press contact',
      PhoneFieldShellPreset.travel => 'Airport pickup',
      PhoneFieldShellPreset.console => 'Hotfix contact line',
    };

PhoneNumber phoneFieldShellInitialValue(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => _softValue,
      PhoneFieldShellPreset.minimal => _minimalValue,
      PhoneFieldShellPreset.travel => _travelValue,
      PhoneFieldShellPreset.console => _consoleValue,
    };

List<IsoCode> phoneFieldShellCountries(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const [IsoCode.US, IsoCode.CA, IsoCode.MX],
      PhoneFieldShellPreset.minimal => const [
          IsoCode.FR,
          IsoCode.BE,
          IsoCode.CH
        ],
      PhoneFieldShellPreset.travel => const [
          IsoCode.GB,
          IsoCode.IE,
          IsoCode.PT
        ],
      PhoneFieldShellPreset.console => const [
          IsoCode.UA,
          IsoCode.PL,
          IsoCode.DE
        ],
    };

List<IsoCode> phoneFieldShellFavoriteCountries(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const [IsoCode.US],
      PhoneFieldShellPreset.minimal => const [IsoCode.FR],
      PhoneFieldShellPreset.travel => const [IsoCode.GB, IsoCode.PT],
      PhoneFieldShellPreset.console => const [IsoCode.UA, IsoCode.PL],
    };

RTextFieldVariant phoneFieldShellVariant(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => RTextFieldVariant.filled,
      PhoneFieldShellPreset.minimal => RTextFieldVariant.underlined,
      PhoneFieldShellPreset.travel => RTextFieldVariant.outlined,
      PhoneFieldShellPreset.console => RTextFieldVariant.outlined,
    };

RPhoneFieldCountryButtonPlacement phoneFieldShellPlacement(
  PhoneFieldShellPreset preset,
) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => RPhoneFieldCountryButtonPlacement.leading,
      PhoneFieldShellPreset.minimal =>
        RPhoneFieldCountryButtonPlacement.trailing,
      PhoneFieldShellPreset.travel => RPhoneFieldCountryButtonPlacement.leading,
      PhoneFieldShellPreset.console => RPhoneFieldCountryButtonPlacement.leading,
    };
