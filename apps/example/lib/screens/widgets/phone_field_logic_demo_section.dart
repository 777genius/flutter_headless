import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'demo_section.dart';
import 'phone_field_compact_overrides.dart';
import 'showcase_fact_pill.dart';

final class PhoneFieldLogicDemoSection extends StatefulWidget {
  const PhoneFieldLogicDemoSection({super.key});

  @override
  State<PhoneFieldLogicDemoSection> createState() =>
      _PhoneFieldLogicDemoSectionState();
}

class _PhoneFieldLogicDemoSectionState
    extends State<PhoneFieldLogicDemoSection> {
  late final RPhoneFieldController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RPhoneFieldController(
      initialValue: PhoneNumber.parse('+380671234567'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Drive The Field From A Controller',
      description:
          'Programmatic updates, plus-paste parsing, max-length limiting, and '
          'validation stay in the controller layer so product flows can own '
          'the field without rewriting internals.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LogicField(controller: _controller),
          const SizedBox(height: 16),
          const _LogicNote(),
          const SizedBox(height: 16),
          _LogicActions(controller: _controller),
          const SizedBox(height: 12),
          _LogicStatus(controller: _controller),
        ],
      ),
    );
  }
}

class _LogicField extends StatelessWidget {
  const _LogicField({required this.controller});

  final RPhoneFieldController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LogicFieldCaption(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: RPhoneField(
            controller: controller,
            placeholder: 'Paste an international number or type locally',
            countries: const [IsoCode.UA, IsoCode.GB, IsoCode.US],
            favoriteCountries: const [IsoCode.UA, IsoCode.US],
            scrollPadding: EdgeInsets.zero,
            fieldOverrides: compactPhoneFieldOverrides(context),
            shouldLimitLengthByCountry: true,
            validator: RPhoneFieldValidator.compose([
              RPhoneFieldValidator.required(),
              RPhoneFieldValidator.valid(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _LogicFieldCaption extends StatelessWidget {
  const _LogicFieldCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Controlled checkout phone field',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _LogicNote extends StatelessWidget {
  const _LogicNote();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer
            .withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Try the buttons to see country switching, normalization, and '
          'selection management without changing the field widget tree.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _LogicActions extends StatelessWidget {
  const _LogicActions({required this.controller});

  final RPhoneFieldController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonal(
          onPressed: () =>
              controller.value = PhoneNumber.parse('+380671234567'),
          child: const Text('Set Kyiv'),
        ),
        FilledButton.tonal(
          onPressed: () => controller.value = PhoneNumber.parse('+12025550148'),
          child: const Text('Set DC'),
        ),
        FilledButton.tonal(
          onPressed: () => controller.changeNationalNumber('+447911123456'),
          child: const Text('Paste +44'),
        ),
        FilledButton.tonal(
          onPressed: controller.selectNationalNumber,
          child: const Text('Select All'),
        ),
        FilledButton.tonal(
          onPressed: () => controller.changeNationalNumber('123'),
          child: const Text('Set Invalid'),
        ),
      ],
    );
  }
}

class _LogicStatus extends StatelessWidget {
  const _LogicStatus({required this.controller});

  final RPhoneFieldController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final value = controller.value;
        return Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ShowcaseFactPill(
              label: 'International',
              value:
                  value.nsn.isEmpty ? 'Waiting for input' : value.international,
            ),
            ShowcaseFactPill(
              label: 'Local',
              value:
                  value.nsn.isEmpty ? 'No local digits yet' : value.formatNsn(),
            ),
            ShowcaseFactPill(
              label: 'Validation',
              value: value.isValid(type: PhoneNumberType.mobile)
                  ? 'Mobile valid'
                  : 'Needs attention',
            ),
          ],
        );
      },
    );
  }
}
