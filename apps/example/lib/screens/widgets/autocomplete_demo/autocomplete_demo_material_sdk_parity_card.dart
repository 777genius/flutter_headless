import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../material_demo_parity_card.dart';

const _parityAnimals = <String>['aardvark', 'bobcat', 'chameleon'];
const _parityPrompt = 'Try: a, bo, or ch';

final _parityAdapter = HeadlessItemAdapter<String>.simple(
  id: (value) => ListboxItemId(value),
  titleText: (value) => value,
);

class AutocompleteDemoMaterialSdkParityCard extends StatefulWidget {
  const AutocompleteDemoMaterialSdkParityCard({super.key});

  @override
  State<AutocompleteDemoMaterialSdkParityCard> createState() =>
      _AutocompleteDemoMaterialSdkParityCardState();
}

class _AutocompleteDemoMaterialSdkParityCardState
    extends State<AutocompleteDemoMaterialSdkParityCard> {
  String _selected = '';

  Iterable<String> _filter(String query) {
    if (query.isEmpty) return const Iterable<String>.empty();
    return _parityAnimals.where((option) => option.contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return MaterialDemoParityCard(
      title: 'Native Flutter vs RAutocomplete',
      caption:
          'The left column is Flutter\'s SDK widget. The right column is our headless widget rendered by the active header preset. In Material mode the chrome can look close on purpose.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 680;
          final columnWidth =
              isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Query hint: $_parityPrompt',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: columnWidth,
                    child: _ParityFieldColumn(
                      keyLabel: 'Flutter SDK',
                      title: 'Autocomplete<T>',
                      helper: 'Prompt: $_parityPrompt',
                      tags: const ['Flutter SDK', 'Native renderer'],
                      child: Autocomplete<String>(
                        initialValue: TextEditingValue(text: _selected),
                        optionsBuilder: (value) {
                          final query = value.text.toLowerCase();
                          return _filter(query);
                        },
                        onSelected: (value) => setState(() => _selected = value),
                        fieldViewBuilder: (
                          context,
                          textController,
                          focusNode,
                          onFieldSubmitted,
                        ) {
                          return TextField(
                            controller: textController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: _parityPrompt,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: columnWidth,
                    child: _ParityFieldColumn(
                      keyLabel: 'Active Headless Preset',
                      title: 'RAutocomplete<T>',
                      helper: 'Prompt: $_parityPrompt',
                      tags: const ['Headless API', 'Header preset'],
                      child: RAutocomplete<String>(
                        key: const Key('autocomplete-parity-field'),
                        source: RAutocompleteLocalSource(
                          options: (value) {
                            final query = value.text.toLowerCase();
                            return _filter(query);
                          },
                        ),
                        itemAdapter: _parityAdapter,
                        onSelected: (value) => setState(() => _selected = value),
                        placeholder: _parityPrompt,
                        semanticLabel: 'Material parity autocomplete',
                        maxOptions: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Current selection: ${_selected.isEmpty ? 'none' : _selected}',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParityFieldColumn extends StatelessWidget {
  const _ParityFieldColumn({
    required this.keyLabel,
    required this.title,
    required this.helper,
    required this.tags,
    required this.child,
  });

  final String keyLabel;
  final String title;
  final String helper;
  final List<String> tags;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      key: Key('autocomplete-parity-column-$keyLabel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MaterialDemoParityLabel(title),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in tags) _ParityMetaPill(label: tag),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          helper,
          style: textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _ParityMetaPill extends StatelessWidget {
  const _ParityMetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
