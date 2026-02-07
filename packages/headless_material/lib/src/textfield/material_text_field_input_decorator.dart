import 'package:flutter/material.dart';

/// Thin [StatelessWidget] wrapper over [InputDecorator].
///
/// Accepts pre-built [InputDecoration], interaction flags, and the [child]
/// (pre-built `EditableText` from the component).
///
/// Does NOT create or manage text editing — that is the component's job.
class MaterialTextFieldInputDecorator extends StatelessWidget {
  const MaterialTextFieldInputDecorator({
    super.key,
    required this.decoration,
    required this.isFocused,
    required this.isHovering,
    required this.isEmpty,
    required this.expands,
    required this.child,
  });

  final InputDecoration decoration;
  final bool isFocused;
  final bool isHovering;
  final bool isEmpty;
  final bool expands;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: decoration,
      isFocused: isFocused,
      isHovering: isHovering,
      isEmpty: isEmpty,
      expands: expands,
      child: child,
    );
  }
}
