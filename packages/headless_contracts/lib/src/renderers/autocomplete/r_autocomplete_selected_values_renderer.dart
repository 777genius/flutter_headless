import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_overrides.dart';
import 'r_autocomplete_selected_values_commands.dart';

/// Renderer capability for selected values display (multi-select autocomplete).
abstract interface class RAutocompleteSelectedValuesRenderer {
  Widget render(RAutocompleteSelectedValuesRenderRequest request);
}

@immutable
final class RAutocompleteSelectedValuesRenderRequest {
  const RAutocompleteSelectedValuesRenderRequest({
    required this.context,
    required this.selectedItems,
    required this.commands,
    this.overrides,
  });

  final BuildContext context;
  final List<HeadlessListItemModel> selectedItems;
  final RAutocompleteSelectedValuesCommands commands;
  final RenderOverrides? overrides;
}
