import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'phone_country_inline_anchor.dart';
import 'phone_country_menu_button.dart';
import 'phone_field_showcase_preview_overrides.dart';
import 'showcase_pill.dart';

class PhoneFieldShowcaseHeroPreview extends StatelessWidget {
  const PhoneFieldShowcaseHeroPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _PhoneFieldPreviewHeader(),
            SizedBox(height: 16),
            _PhoneFieldPreviewField(),
            SizedBox(height: 14),
            _PhoneFieldPreviewPills(),
          ],
        ),
      ),
    );
  }
}

class _PhoneFieldPreviewHeader extends StatelessWidget {
  const _PhoneFieldPreviewHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'The same behavior core can be wrapped by a branded shell.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _PhoneFieldPreviewField extends StatelessWidget {
  const _PhoneFieldPreviewField();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhoneFieldPreviewCaption(),
        SizedBox(height: 8),
        _PhoneFieldPreviewInput(),
      ],
    );
  }
}

class _PhoneFieldPreviewCaption extends StatelessWidget {
  const _PhoneFieldPreviewCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Support line',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _PhoneFieldPreviewInput extends StatefulWidget {
  const _PhoneFieldPreviewInput();

  @override
  State<_PhoneFieldPreviewInput> createState() =>
      _PhoneFieldPreviewInputState();
}

class _PhoneFieldPreviewInputState extends State<_PhoneFieldPreviewInput> {
  static const _initialValue = PhoneNumber(
    isoCode: IsoCode.US,
    nsn: '2025550148',
  );

  final _controller = RPhoneFieldController(initialValue: _initialValue);
  final _previewNumberResolver = const RPhoneFieldSampleNumberResolver();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCountryChanged(IsoCode isoCode) {
    _controller.value = _previewNumberResolver.resolve(isoCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: RPhoneField(
            key: const ValueKey('phone-field-preview-demo'),
            controller: _controller,
            onChanged: ignorePhoneShowcaseChange,
            onCountryChanged: _handleCountryChanged,
            countrySelectorNavigator:
                const RPhoneFieldCountrySelectorNavigator.menu(
              height: 360,
              searchAutofocus: true,
            ),
            style: const RPhoneFieldStyle(
              countryButtonPlacement: RPhoneFieldCountryButtonPlacement.leading,
            ),
            scrollPadding: EdgeInsets.zero,
            fieldOverrides: phoneFieldShowcasePreviewOverrides(),
            countryButtonBuilder: previewPhoneCountryButton,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Open the country menu without rewriting parsing.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _PhoneFieldPreviewPills extends StatelessWidget {
  const _PhoneFieldPreviewPills();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ShowcasePill(
          icon: Icons.lock_open_rounded,
          label: 'No visual lock-in',
        ),
        ShowcasePill(
          icon: Icons.keyboard_command_key_rounded,
          label: 'Same public contracts',
        ),
      ],
    );
  }
}

Widget previewPhoneCountryButton(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
) {
  return PhoneCountryMenuButton(
    key: const ValueKey('phone-field-preview-country-trigger'),
    request: request,
    constraints: const BoxConstraints(
      minWidth: 126,
      minHeight: 44,
    ),
    anchorBuilder: (context, request, isOpen) => PhoneCountryInlineAnchor(
      request: request,
      isOpen: isOpen,
      chipMinWidth: 112,
      chipMinHeight: 38,
      chipPadding: EdgeInsetsDirectional.only(
        start: 10,
        end: 8,
        top: 6,
        bottom: 6,
      ),
      dividerGap: 6,
      outerPadding: EdgeInsets.zero,
    ),
  );
}

void ignorePhoneShowcaseChange(PhoneNumber _) {}
