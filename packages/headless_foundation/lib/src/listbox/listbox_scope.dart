import 'package:flutter/widgets.dart';

import 'listbox_controller.dart';

class ListboxScope extends InheritedNotifier<ListboxController> {
  const ListboxScope({
    super.key,
    required ListboxController controller,
    required super.child,
  }) : super(notifier: controller);

  static ListboxController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ListboxScope>();
    assert(scope != null, 'ListboxScope not found in widget tree');
    return scope!.notifier!;
  }

  static ListboxController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListboxScope>()?.notifier;
  }
}
