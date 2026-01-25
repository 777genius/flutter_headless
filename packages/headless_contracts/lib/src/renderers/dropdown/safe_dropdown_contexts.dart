import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'r_dropdown_commands.dart';
import 'r_dropdown_resolved_tokens.dart';
import 'r_dropdown_spec.dart';
import 'r_dropdown_state.dart';

typedef SafeDropdownTriggerBuilder = Widget Function(
  SafeDropdownTriggerContext context,
);
typedef SafeDropdownMenuSurfaceBuilder = Widget Function(
  SafeDropdownMenuSurfaceContext context,
);
typedef SafeDropdownItemBuilder = Widget Function(
  SafeDropdownItemContext context,
);
typedef SafeDropdownItemContentBuilder = Widget Function(
  SafeDropdownItemContentContext context,
);
typedef SafeDropdownEmptyStateBuilder = Widget Function(
  SafeDropdownEmptyStateContext context,
);
typedef SafeDropdownChevronBuilder = Widget Function(
  SafeDropdownChevronContext context,
);

@immutable
final class SafeDropdownTriggerContext {
  const SafeDropdownTriggerContext({
    required this.spec,
    required this.state,
    required this.selectedItem,
    required this.displayText,
    required this.commands,
    required this.child,
    this.chevron,
    this.visualEffects,
  });

  final RDropdownButtonSpec spec;
  final RDropdownButtonState state;
  final HeadlessListItemModel? selectedItem;
  final String displayText;
  final RDropdownCommands commands;
  final Widget child;
  final Widget? chevron;
  final HeadlessPressableVisualEffectsController? visualEffects;
}

@immutable
final class SafeDropdownMenuSurfaceContext {
  const SafeDropdownMenuSurfaceContext({
    required this.spec,
    required this.state,
    required this.child,
    required this.commands,
    this.resolvedTokens,
  });

  final RDropdownButtonSpec spec;
  final RDropdownButtonState state;
  final Widget child;
  final RDropdownCommands commands;
  final RDropdownResolvedTokens? resolvedTokens;
}

@immutable
final class SafeDropdownItemContext {
  const SafeDropdownItemContext({
    required this.item,
    required this.index,
    required this.isHighlighted,
    required this.isSelected,
    required this.child,
  });

  final HeadlessListItemModel item;
  final int index;
  final bool isHighlighted;
  final bool isSelected;
  final Widget child;
}

@immutable
final class SafeDropdownItemContentContext {
  const SafeDropdownItemContentContext({
    required this.item,
    required this.index,
    required this.isHighlighted,
    required this.isSelected,
    required this.child,
  });

  final HeadlessListItemModel item;
  final int index;
  final bool isHighlighted;
  final bool isSelected;
  final Widget child;
}

@immutable
final class SafeDropdownEmptyStateContext {
  const SafeDropdownEmptyStateContext({
    required this.spec,
    required this.state,
    required this.commands,
  });

  final RDropdownButtonSpec spec;
  final RDropdownButtonState state;
  final RDropdownCommands commands;
}

@immutable
final class SafeDropdownChevronContext {
  const SafeDropdownChevronContext({
    required this.spec,
    required this.state,
    required this.selectedItem,
    required this.commands,
  });

  final RDropdownButtonSpec spec;
  final RDropdownButtonState state;
  final HeadlessListItemModel? selectedItem;
  final RDropdownCommands commands;
}
