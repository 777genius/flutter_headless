import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'demo_section.dart';
import 'phone_country_menu_button.dart';
import 'phone_country_showcase_anchor.dart';
import 'phone_field_showcase_theme_scope.dart';
import 'showcase_fact_pill.dart';

final class PhoneFieldCustomTriggerDemoSection extends StatefulWidget {
  const PhoneFieldCustomTriggerDemoSection({super.key});

  @override
  State<PhoneFieldCustomTriggerDemoSection> createState() =>
      _PhoneFieldCustomTriggerDemoSectionState();
}

class _PhoneFieldCustomTriggerDemoSectionState
    extends State<PhoneFieldCustomTriggerDemoSection> {
  RPhoneFieldCountryButtonPlacement _placement =
      RPhoneFieldCountryButtonPlacement.prefix;
  PhoneNumber _value = PhoneNumber.parse('+48501234567');

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Brand The Trigger, Keep The Contracts',
      description:
          'The visual country trigger is just a slot. Teams can replace the '
          'design and move it between leading, prefix, trailing, or suffix '
          'without forking phone behavior. The same trigger can still open a '
          'searchable country menu.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomTriggerPlacementPicker(
            placement: _placement,
            onChanged: (placement) => setState(() => _placement = placement),
          ),
          const SizedBox(height: 16),
          _CustomTriggerField(
            placement: _placement,
            value: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
          const SizedBox(height: 12),
          _CustomTriggerSummary(
            placementLabel: _placementLabel,
            countryCode: _value.isoCode.name,
            dialCode: '+${_value.countryCode}',
          ),
        ],
      ),
    );
  }

  String get _placementLabel => switch (_placement) {
        RPhoneFieldCountryButtonPlacement.leading => 'Leading slot',
        RPhoneFieldCountryButtonPlacement.prefix => 'Prefix slot',
        RPhoneFieldCountryButtonPlacement.trailing => 'Trailing slot',
        RPhoneFieldCountryButtonPlacement.suffix => 'Suffix slot',
      };
}

class _CustomTriggerPlacementPicker extends StatelessWidget {
  const _CustomTriggerPlacementPicker({
    required this.placement,
    required this.onChanged,
  });

  final RPhoneFieldCountryButtonPlacement placement;
  final ValueChanged<RPhoneFieldCountryButtonPlacement> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<RPhoneFieldCountryButtonPlacement>(
      segments: const [
        ButtonSegment(
          value: RPhoneFieldCountryButtonPlacement.leading,
          label: Text('Leading'),
        ),
        ButtonSegment(
          value: RPhoneFieldCountryButtonPlacement.prefix,
          label: Text('Prefix'),
        ),
        ButtonSegment(
          value: RPhoneFieldCountryButtonPlacement.trailing,
          label: Text('Trailing'),
        ),
        ButtonSegment(
          value: RPhoneFieldCountryButtonPlacement.suffix,
          label: Text('Suffix'),
        ),
      ],
      selected: {placement},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _CustomTriggerField extends StatelessWidget {
  const _CustomTriggerField({
    required this.placement,
    required this.value,
    required this.onChanged,
  });

  final RPhoneFieldCountryButtonPlacement placement;
  final PhoneNumber value;
  final ValueChanged<PhoneNumber> onChanged;

  @override
  Widget build(BuildContext context) {
    return PhoneFieldShowcaseThemeScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CustomTriggerFieldCaption(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: RPhoneField(
              key: const ValueKey('phone-field-custom-trigger-demo'),
              value: value,
              onChanged: onChanged,
              placeholder: 'Enter a local number',
              countries: const [IsoCode.PL, IsoCode.DE, IsoCode.FR, IsoCode.ES],
              favoriteCountries: const [IsoCode.PL, IsoCode.DE],
              scrollPadding: EdgeInsets.zero,
              fieldOverrides: customTriggerPhoneFieldOverrides(),
              countrySelectorNavigator:
                  const RPhoneFieldCountrySelectorNavigator.menu(
                height: 360,
                searchAutofocus: true,
              ),
              style: RPhoneFieldStyle(countryButtonPlacement: placement),
              countryButtonBuilder: (context, request) =>
                  brandedPhoneCountryButton(context, request, placement),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTriggerFieldCaption extends StatelessWidget {
  const _CustomTriggerFieldCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Checkout contact',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _CustomTriggerSummary extends StatelessWidget {
  const _CustomTriggerSummary({
    required this.placementLabel,
    required this.countryCode,
    required this.dialCode,
  });

  final String placementLabel;
  final String countryCode;
  final String dialCode;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        ShowcaseFactPill(label: 'Placement', value: placementLabel),
        ShowcaseFactPill(label: 'Country', value: countryCode),
        ShowcaseFactPill(label: 'Dial code', value: dialCode),
      ],
    );
  }
}

Widget brandedPhoneCountryButton(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
  RPhoneFieldCountryButtonPlacement placement,
) {
  return PhoneCountryMenuButton(
    request: request,
    anchorBuilder: (context, request, isOpen) => PhoneCountryShowcaseAnchor(
      request: request,
      isOpen: isOpen,
      placement: placement,
    ),
  );
}

RenderOverrides customTriggerPhoneFieldOverrides() {
  return const RenderOverrides({
    RTextFieldOverrides: RTextFieldOverrides.tokens(
      containerPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      containerBorderRadius: BorderRadius.all(Radius.circular(18)),
      containerBackgroundColor: Color(0xFFF9F6FE),
      iconSpacing: 10,
      minSize: Size(0, 50),
    ),
  });
}
