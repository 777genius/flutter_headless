import 'package:flutter/widgets.dart';

/// Wraps a text field subtree with Flutter's default text selection gesture
/// handling (as used by `TextField` / `CupertinoTextField`).
///
/// This is critical for web: it keeps pointer/gesture handling consistent with
/// Flutter's own text field widgets and avoids subtle platform differences when
/// using [EditableText] directly.
final class RTextFieldSelectionGestureWrapper extends StatefulWidget {
  const RTextFieldSelectionGestureWrapper({
    required this.editableTextKey,
    required this.selectionEnabled,
    required this.child,
    super.key,
  });

  final GlobalKey<EditableTextState> editableTextKey;
  final bool selectionEnabled;
  final Widget child;

  @override
  State<RTextFieldSelectionGestureWrapper> createState() =>
      _RTextFieldSelectionGestureWrapperState();
}

final class _RTextFieldSelectionGestureWrapperState
    extends State<RTextFieldSelectionGestureWrapper>
    implements TextSelectionGestureDetectorBuilderDelegate {
  late TextSelectionGestureDetectorBuilder _builder;

  @override
  void initState() {
    super.initState();
    _builder = TextSelectionGestureDetectorBuilder(delegate: this);
  }

  @override
  void didUpdateWidget(RTextFieldSelectionGestureWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recreate builder if the key object changed.
    if (oldWidget.editableTextKey != widget.editableTextKey) {
      _builder = TextSelectionGestureDetectorBuilder(delegate: this);
    }
  }

  @override
  GlobalKey<EditableTextState> get editableTextKey => widget.editableTextKey;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  @override
  Widget build(BuildContext context) {
    // Keep this subtree in the default TextField tap region group.
    //
    // This matches Flutter's `TextField` behavior and is important on web:
    // without a `TextFieldTapRegion`, a focused DOM-backed EditableText may
    // treat taps on external UI (e.g. AppBar actions) as "outside" taps and
    // consume them, effectively requiring a second tap.
    return TextFieldTapRegion(
      child: _builder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

