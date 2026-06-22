import 'package:flutter/widgets.dart';

import '../controllers/adaptive_pane_controller.dart';
import '../core/adaptive_environment.dart';
import '../core/adaptive_layout.dart';
import '../core/adaptive_policy.dart';
import 'adaptive_slot_layout.dart';

class AdaptiveListDetailScaffold extends StatelessWidget {
  const AdaptiveListDetailScaffold({
    super.key,
    required this.list,
    required this.detail,
    this.supporting,
    this.policy,
    this.environment,
    this.inputCapabilities,
    this.controller,
    this.initialPane,
    this.gap = 0,
  });

  final AdaptiveSlotBuilder list;
  final AdaptiveSlotBuilder detail;
  final AdaptiveSlotBuilder? supporting;
  final AdaptivePolicy? policy;
  final AdaptiveEnvironment? environment;
  final Set<AdaptiveInputCapability>? inputCapabilities;
  final AdaptivePaneController? controller;
  final AdaptivePaneRole? initialPane;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return AdaptiveSlotLayout(
      policy: policy,
      environment: environment,
      inputCapabilities: inputCapabilities,
      controller: controller,
      initialPane: initialPane,
      gap: gap,
      slots: AdaptiveSlots(
        primary: list,
        detail: detail,
        supporting: supporting,
      ),
    );
  }
}
