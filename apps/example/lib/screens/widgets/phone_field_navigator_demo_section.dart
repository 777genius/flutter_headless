import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'demo_section.dart';
import 'phone_field_compact_overrides.dart';
import 'phone_country_inline_anchor.dart';
import 'phone_country_menu_button.dart';
import 'phone_field_navigator_menu_launcher.dart';
import 'phone_field_navigator_status.dart';

enum PhoneFieldDemoNavigatorMode {
  page('Page'),
  dialog('Dialog'),
  sheet('Sheet'),
  menu('Menu');

  const PhoneFieldDemoNavigatorMode(this.label);

  final String label;
}

final class PhoneFieldNavigatorDemoSection extends StatefulWidget {
  const PhoneFieldNavigatorDemoSection({super.key});

  @override
  State<PhoneFieldNavigatorDemoSection> createState() =>
      _PhoneFieldNavigatorDemoSectionState();
}

class _PhoneFieldNavigatorDemoSectionState
    extends State<PhoneFieldNavigatorDemoSection> {
  PhoneFieldDemoNavigatorMode _mode = PhoneFieldDemoNavigatorMode.menu;
  PhoneNumber _value = PhoneNumber.parse('+12025550148');

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Switch The Country Picker, Keep The Field Logic',
      description:
          'Parsing, formatting, and validation stay fixed while country search '
          'moves between a full route, a dialog, a bottom sheet, or an '
          'anchored menu with inline search.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NavigatorModePicker(
            mode: _mode,
            onChanged: (mode) => setState(() => _mode = mode),
          ),
          const SizedBox(height: 16),
          _NavigatorSummary(
            mode: _mode,
            flowSupportingText: _flowSupportingText,
          ),
          const SizedBox(height: 12),
          PhoneFieldNavigatorMenuLauncher(
            value: _value,
            navigator: _navigator,
            countries: const [IsoCode.US, IsoCode.PL, IsoCode.UA, IsoCode.GB],
            favoriteCountries: const [IsoCode.US, IsoCode.PL, IsoCode.UA],
            onCountrySelected: _handleLauncherCountrySelected,
          ),
          const SizedBox(height: 12),
          _NavigatorField(
            value: _value,
            navigator: _navigator,
            onChanged: (value) => setState(() => _value = value),
          ),
          const SizedBox(height: 12),
          PhoneFieldNavigatorStatus(
            mode: _mode,
            countryCode: _value.isoCode.name,
            internationalValue: _internationalValue,
          ),
        ],
      ),
    );
  }

  String get _flowSupportingText => switch (_mode) {
        PhoneFieldDemoNavigatorMode.page =>
          'Best for dedicated search and navigation.',
        PhoneFieldDemoNavigatorMode.dialog =>
          'Best for tablet and desktop density.',
        PhoneFieldDemoNavigatorMode.sheet =>
          'Best default for mobile touch flows.',
        PhoneFieldDemoNavigatorMode.menu =>
          'Best when country switching should stay inline and fast.',
      };

  String get _internationalValue =>
      _value.nsn.isEmpty ? 'Waiting for input' : _value.international;

  void _handleLauncherCountrySelected(IsoCode country) {
    final controller = RPhoneFieldController(initialValue: _value);
    controller.changeCountry(country, maxDigits: null);
    setState(() => _value = controller.value);
    controller.dispose();
  }

  RPhoneFieldCountrySelectorNavigator get _navigator => switch (_mode) {
        PhoneFieldDemoNavigatorMode.page =>
          const RPhoneFieldCountrySelectorNavigator.page(
            searchAutofocus: true,
          ),
        PhoneFieldDemoNavigatorMode.dialog =>
          const RPhoneFieldCountrySelectorNavigator.dialog(
            width: 480,
            height: 560,
            searchAutofocus: true,
          ),
        PhoneFieldDemoNavigatorMode.sheet =>
          const RPhoneFieldCountrySelectorNavigator.modalBottomSheet(
            height: 560,
            searchAutofocus: true,
          ),
        PhoneFieldDemoNavigatorMode.menu =>
          const RPhoneFieldCountrySelectorNavigator.menu(
            height: 360,
            searchAutofocus: true,
          ),
      };
}

class _NavigatorModePicker extends StatelessWidget {
  const _NavigatorModePicker({
    required this.mode,
    required this.onChanged,
  });

  final PhoneFieldDemoNavigatorMode mode;
  final ValueChanged<PhoneFieldDemoNavigatorMode> onChanged;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PhoneFieldDemoNavigatorMode>(
      segments: [
        for (final item in PhoneFieldDemoNavigatorMode.values)
          ButtonSegment<PhoneFieldDemoNavigatorMode>(
            value: item,
            label: Text(item.label),
          ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _NavigatorField extends StatelessWidget {
  const _NavigatorField({
    required this.value,
    required this.navigator,
    required this.onChanged,
  });

  final PhoneNumber value;
  final RPhoneFieldCountrySelectorNavigator navigator;
  final ValueChanged<PhoneNumber> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NavigatorFieldCaption(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: RPhoneField(
            key: const ValueKey('phone-field-navigator-demo'),
            value: value,
            onChanged: onChanged,
            placeholder: 'Paste +44 7911 123456 or type locally',
            countrySelectorNavigator: navigator,
            favoriteCountries: const [IsoCode.US, IsoCode.PL, IsoCode.UA],
            shouldLimitLengthByCountry: true,
            scrollPadding: EdgeInsets.zero,
            fieldOverrides: compactPhoneFieldOverrides(context),
            style: const RPhoneFieldStyle(
              countryButtonPlacement: RPhoneFieldCountryButtonPlacement.leading,
            ),
            countryButtonBuilder: inlinePhoneCountryMenuButton,
            validator: RPhoneFieldValidator.valid(),
          ),
        ),
      ],
    );
  }
}

class _NavigatorFieldCaption extends StatelessWidget {
  const _NavigatorFieldCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Support number',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _NavigatorSummary extends StatelessWidget {
  const _NavigatorSummary({
    required this.mode,
    required this.flowSupportingText,
  });

  final PhoneFieldDemoNavigatorMode mode;
  final String flowSupportingText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${mode.label} flow. ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          TextSpan(
            text: flowSupportingText,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

Widget inlinePhoneCountryMenuButton(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
) {
  return PhoneCountryMenuButton(
    request: request,
    constraints: const BoxConstraints(
      minWidth: 82,
      minHeight: 32,
    ),
    anchorBuilder: (context, request, isOpen) => PhoneCountryInlineAnchor(
      request: request,
      isOpen: isOpen,
      chipMinHeight: 32,
      chipPadding: EdgeInsetsDirectional.only(
        start: 8,
        end: 6,
        top: 4,
        bottom: 4,
      ),
      dividerGap: 4,
      outerPadding: EdgeInsetsDirectional.zero,
      flagGap: 4,
      dialCodeGap: 1,
      arrowSize: 16,
    ),
  );
}
