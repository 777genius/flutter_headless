import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'material_button_parity_constants.dart';
import 'material_parity_button_state_adapter.dart';
import 'material_parity_button_style_factory.dart';

/// Material parity renderer that delegates visual rendering to Flutter's
/// own [FilledButton] / [OutlinedButton] widgets.
///
/// This guarantees pixel-perfect Material 3 visuals (parity-by-reuse)
/// instead of hand-rolling the look.
///
/// Variant mapping:
/// - `filled` → [FilledButton]
/// - `tonal` → [FilledButton.tonal]
/// - `outlined` → [OutlinedButton]
/// - `text` → [TextButton]
///
/// The renderer wraps the Flutter button in an inert guard
/// (`ExcludeSemantics` + `AbsorbPointer`) so that activation remains
/// solely in the component layer ([RTextButton]).
class MaterialFlutterParityButtonRenderer
    implements RButtonRenderer, RButtonRendererTokenMode {
  const MaterialFlutterParityButtonRenderer();

  @override
  bool get usesResolvedTokens => false;

  @override
  Widget render(RButtonRenderRequest request) {
    _assertMaterial3(request.context);
    return _MaterialParityButtonShell(request: request);
  }

  static void _assertMaterial3(BuildContext context) {
    final theme = Theme.of(context);
    if (!theme.useMaterial3) {
      throw StateError(
        '[Headless] MaterialFlutterParityButtonRenderer requires Material 3.\n'
        'Set useMaterial3: true in your ThemeData.',
      );
    }
  }
}

class _MaterialParityButtonShell extends StatefulWidget {
  const _MaterialParityButtonShell({required this.request});

  final RButtonRenderRequest request;

  @override
  State<_MaterialParityButtonShell> createState() =>
      _MaterialParityButtonShellState();
}

class _MaterialParityButtonShellState
    extends State<_MaterialParityButtonShell> {
  late WidgetStatesController _statesController;
  late FocusNode _inertFocusNode;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController(
      MaterialParityButtonStateAdapter.toWidgetStates(widget.request.state),
    );
    _inertFocusNode = FocusNode(
      canRequestFocus: false,
      skipTraversal: true,
    );
  }

  @override
  void didUpdateWidget(_MaterialParityButtonShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _statesController.value =
        MaterialParityButtonStateAdapter.toWidgetStates(widget.request.state);
  }

  @override
  void dispose() {
    _statesController.dispose();
    _inertFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final variant = request.spec.variant;
    final isOutlined = variant == RButtonVariant.outlined;
    final overrideStyle = MaterialParityButtonStyleFactory.fromOverrides(
      request.overrides,
      isOutlined: isOutlined,
    );

    // Tap target padding is handled by the component (via HeadlessTapTargetPolicy).
    // Force Flutter button to return visual-only size (no _InputPadding inflation).
    // Size mapping follows M3 Expressive: small→S(36dp), medium→M(40dp), large→L(48dp).
    final sizeStyle = _mapSizeButtonStyle(request.spec.size, context);
    final baseStyle = const ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ).merge(sizeStyle);
    final effectiveStyle =
        overrideStyle != null ? baseStyle.merge(overrideStyle) : baseStyle;

    final onPressed = request.state.isDisabled ? null : () {};

    final Widget flutterButton = switch (variant) {
      RButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          style: effectiveStyle,
          statesController: _statesController,
          focusNode: _inertFocusNode,
          child: request.content,
        ),
      RButtonVariant.tonal => FilledButton.tonal(
          onPressed: onPressed,
          style: effectiveStyle,
          statesController: _statesController,
          focusNode: _inertFocusNode,
          child: request.content,
        ),
      RButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          style: effectiveStyle,
          statesController: _statesController,
          focusNode: _inertFocusNode,
          child: request.content,
        ),
      RButtonVariant.text => TextButton(
          onPressed: onPressed,
          style: effectiveStyle,
          statesController: _statesController,
          focusNode: _inertFocusNode,
          child: request.content,
        ),
    };

    return ExcludeSemantics(
      child: AbsorbPointer(
        absorbing: true,
        child: flutterButton,
      ),
    );
  }
}

/// Maps [RButtonSize] to a size-specific [ButtonStyle] per M3 Expressive.
///
/// Heights: small→36dp (S), medium→40dp (M), large→48dp (L).
ButtonStyle _mapSizeButtonStyle(RButtonSize size, BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  switch (size) {
    case RButtonSize.small:
      return ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(64, MaterialButtonParityConstants.kSmallMinHeight),
        ),
        padding: const WidgetStatePropertyAll(
          MaterialButtonParityConstants.kSmallPadding,
        ),
        textStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      );
    case RButtonSize.medium:
      return const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(64, MaterialButtonParityConstants.kMediumMinHeight),
        ),
        padding: WidgetStatePropertyAll(
          MaterialButtonParityConstants.kMediumPadding,
        ),
      );
    case RButtonSize.large:
      return ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(64, MaterialButtonParityConstants.kLargeMinHeight),
        ),
        padding: const WidgetStatePropertyAll(
          MaterialButtonParityConstants.kLargePadding,
        ),
        textStyle: WidgetStatePropertyAll(textTheme.titleMedium),
      );
  }
}
