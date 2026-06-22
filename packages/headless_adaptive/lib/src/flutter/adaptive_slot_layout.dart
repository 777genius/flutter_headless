import 'package:flutter/widgets.dart';

import '../controllers/adaptive_pane_controller.dart';
import '../core/adaptive_environment.dart';
import '../core/adaptive_layout.dart';
import '../core/adaptive_policy.dart';
import '../core/adaptive_state.dart';
import 'adaptive_builder.dart';

typedef AdaptiveSlotBuilder =
    Widget Function(BuildContext context, AdaptiveSlotState state);

final class AdaptiveSlots {
  const AdaptiveSlots({required this.primary, this.detail, this.supporting});

  final AdaptiveSlotBuilder primary;
  final AdaptiveSlotBuilder? detail;
  final AdaptiveSlotBuilder? supporting;

  bool has(AdaptivePaneRole role) {
    return switch (role) {
      AdaptivePaneRole.primary => true,
      AdaptivePaneRole.detail => detail != null,
      AdaptivePaneRole.supporting => supporting != null,
    };
  }

  AdaptiveSlotBuilder? maybeBuilderFor(AdaptivePaneRole role) {
    return switch (role) {
      AdaptivePaneRole.primary => primary,
      AdaptivePaneRole.detail => detail,
      AdaptivePaneRole.supporting => supporting,
    };
  }

  AdaptiveSlotBuilder builderFor(AdaptivePaneRole role) {
    final builder = maybeBuilderFor(role);
    if (builder == null) {
      throw StateError('No AdaptiveSlotBuilder configured for $role.');
    }
    return builder;
  }
}

final class AdaptiveSlotState {
  const AdaptiveSlotState({
    required this.role,
    required this.visibility,
    required this.isSelected,
    required this.adaptive,
  });

  final AdaptivePaneRole role;
  final AdaptivePaneVisibility visibility;
  final bool isSelected;
  final AdaptiveState adaptive;
}

class AdaptiveSlotLayout extends StatefulWidget {
  const AdaptiveSlotLayout({
    super.key,
    required this.slots,
    this.policy,
    this.environment,
    this.inputCapabilities,
    this.controller,
    this.initialPane,
    this.gap = 0,
  }) : assert(gap >= 0, 'gap must be non-negative');

  final AdaptiveSlots slots;
  final AdaptivePolicy? policy;
  final AdaptiveEnvironment? environment;
  final Set<AdaptiveInputCapability>? inputCapabilities;
  final AdaptivePaneController? controller;
  final AdaptivePaneRole? initialPane;
  final double gap;

  @override
  State<AdaptiveSlotLayout> createState() => _AdaptiveSlotLayoutState();
}

class _AdaptiveSlotLayoutState extends State<AdaptiveSlotLayout> {
  late AdaptivePaneController _localController;

  AdaptivePaneController get _controller {
    return widget.controller ?? _localController;
  }

  @override
  void initState() {
    super.initState();
    _localController = AdaptivePaneController(
      initialPane: _initialLocalPane(widget),
    );
  }

  @override
  void didUpdateWidget(covariant AdaptiveSlotLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        (oldWidget.initialPane != widget.initialPane ||
            oldWidget.policy?.panes.singlePaneFallback !=
                widget.policy?.panes.singlePaneFallback)) {
      _localController.selectPane(_initialLocalPane(widget));
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      policy: widget.policy,
      environment: widget.environment,
      inputCapabilities: widget.inputCapabilities,
      builder: (context, adaptive) {
        return ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return _buildSlots(context, adaptive);
          },
        );
      },
    );
  }

  Widget _buildSlots(BuildContext context, AdaptiveState adaptive) {
    final inlineRoles = [
      for (final role in adaptive.decision.visiblePanes)
        if (widget.slots.has(role)) role,
    ];

    if (inlineRoles.length <= 1) {
      final fallbackRole =
          widget.slots.has(adaptive.policy.panes.singlePaneFallback)
          ? adaptive.policy.panes.singlePaneFallback
          : AdaptivePaneRole.primary;
      final selectedRole =
          _usesExplicitPaneSelection &&
              widget.slots.has(_controller.selectedPane)
          ? _controller.selectedPane
          : fallbackRole;
      final builder = widget.slots.builderFor(selectedRole);
      return builder(
        context,
        AdaptiveSlotState(
          role: selectedRole,
          visibility: AdaptivePaneVisibility.single,
          isSelected: true,
          adaptive: adaptive,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < inlineRoles.length; index++) ...[
          if (index > 0 && widget.gap > 0) SizedBox(width: widget.gap),
          Expanded(
            flex: adaptive.policy.panes.flexFor(inlineRoles[index]),
            child: widget.slots.builderFor(inlineRoles[index])(
              context,
              AdaptiveSlotState(
                role: inlineRoles[index],
                visibility: AdaptivePaneVisibility.inline,
                isSelected: inlineRoles[index] == _controller.selectedPane,
                adaptive: adaptive,
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool get _usesExplicitPaneSelection {
    return widget.controller != null || widget.initialPane != null;
  }

  AdaptivePaneRole _initialLocalPane(AdaptiveSlotLayout widget) {
    final requested =
        widget.initialPane ??
        widget.policy?.panes.singlePaneFallback ??
        AdaptivePaneRole.primary;
    return widget.slots.has(requested) ? requested : AdaptivePaneRole.primary;
  }
}
