import 'package:flutter/foundation.dart';

import '../core/adaptive_layout.dart';

final class AdaptivePaneController extends ChangeNotifier {
  AdaptivePaneController({
    AdaptivePaneRole initialPane = AdaptivePaneRole.primary,
  }) : _selectedPane = initialPane;

  AdaptivePaneRole _selectedPane;

  AdaptivePaneRole get selectedPane => _selectedPane;

  void selectPane(AdaptivePaneRole pane) {
    if (_selectedPane == pane) {
      return;
    }
    _selectedPane = pane;
    notifyListeners();
  }
}
