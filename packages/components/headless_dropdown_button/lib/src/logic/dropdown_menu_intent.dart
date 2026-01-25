/// Pure intent model for dropdown menu keyboard navigation.
///
/// No Flutter dependencies by design.
sealed class DropdownMenuIntent {
  const DropdownMenuIntent();
}

final class CloseMenuIntent extends DropdownMenuIntent {
  const CloseMenuIntent();
}

final class MoveHighlightUpIntent extends DropdownMenuIntent {
  const MoveHighlightUpIntent();
}

final class MoveHighlightDownIntent extends DropdownMenuIntent {
  const MoveHighlightDownIntent();
}

final class JumpToFirstIntent extends DropdownMenuIntent {
  const JumpToFirstIntent();
}

final class JumpToLastIntent extends DropdownMenuIntent {
  const JumpToLastIntent();
}

final class SelectHighlightedIntent extends DropdownMenuIntent {
  const SelectHighlightedIntent();
}

final class TypeaheadIntent extends DropdownMenuIntent {
  const TypeaheadIntent(this.char);
  final String char;
}

