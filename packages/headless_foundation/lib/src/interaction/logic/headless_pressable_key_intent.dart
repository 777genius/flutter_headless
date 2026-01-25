/// Keyboard intent for pressable surfaces (buttons, dropdown triggers).
///
/// Pure model: no Flutter dependencies.
sealed class HeadlessPressableKeyIntent {
  const HeadlessPressableKeyIntent();
}

final class HeadlessPressableSpaceDown extends HeadlessPressableKeyIntent {
  const HeadlessPressableSpaceDown();
}

final class HeadlessPressableSpaceUp extends HeadlessPressableKeyIntent {
  const HeadlessPressableSpaceUp();
}

final class HeadlessPressableEnterDown extends HeadlessPressableKeyIntent {
  const HeadlessPressableEnterDown();
}

final class HeadlessPressableEnterUp extends HeadlessPressableKeyIntent {
  const HeadlessPressableEnterUp();
}

final class HeadlessPressableArrowDown extends HeadlessPressableKeyIntent {
  const HeadlessPressableArrowDown();
}

