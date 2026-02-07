/// Абстрактные команды навигации listbox.
///
/// KeyEvent → ListboxNavigation конвертация должна жить в presentation слое
/// конкретного компонента.
sealed class ListboxNavigation {
  const ListboxNavigation();
}

/// Переместить highlight на delta (+1 вниз, -1 вверх).
final class MoveHighlight extends ListboxNavigation {
  const MoveHighlight(this.delta);
  final int delta;
}

final class JumpToFirst extends ListboxNavigation {
  const JumpToFirst();
}

final class JumpToLast extends ListboxNavigation {
  const JumpToLast();
}

final class TypeaheadChar extends ListboxNavigation {
  const TypeaheadChar(this.char);
  final String char;
}

final class SelectHighlighted extends ListboxNavigation {
  const SelectHighlighted();
}
