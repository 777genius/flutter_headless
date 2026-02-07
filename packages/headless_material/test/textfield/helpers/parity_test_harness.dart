import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

const parityRenderer = MaterialTextFieldRenderer();

/// Builds renderer-side field with [EditableText].
///
/// Renderer uses [RTextFieldState.isFocused] (not `FocusNode.hasFocus`) for
/// [InputDecorator]. For EditableText consistency, callers should also call
/// `requestFocus()` on the passed [focusNode] in focused tests.
///
/// Hover: [RTextFieldState.isHovered] is passed directly — no mouse
/// emulation needed.
Widget buildRendererField(
  BuildContext context, {
  RTextFieldSpec spec = const RTextFieldSpec(),
  RTextFieldState state = const RTextFieldState(),
  RTextFieldSlots? slots,
  TextEditingController? controller,
  FocusNode? focusNode,
}) {
  final effectiveController = controller ?? TextEditingController();
  final effectiveFocusNode = focusNode ?? FocusNode();
  final style =
      Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);

  final input = EditableText(
    controller: effectiveController,
    focusNode: effectiveFocusNode,
    style: style,
    cursorColor: Theme.of(context).colorScheme.primary,
    backgroundCursorColor: Theme.of(context).colorScheme.onSurface,
    showCursor: false,
  );

  return parityRenderer.render(
    RTextFieldRenderRequest(
      context: context,
      input: input,
      spec: spec,
      state: state,
      slots: slots,
    ),
  );
}

Widget buildNativeTextField({
  RTextFieldVariant variant = RTextFieldVariant.filled,
  String? label,
  String? placeholder,
  String? helperText,
  String? errorText,
  bool enabled = true,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Widget? prefix,
  Widget? suffix,
  TextEditingController? controller,
  FocusNode? focusNode,
  int? maxLines = 1,
  bool showCursor = false,
}) {
  final border = switch (variant) {
    RTextFieldVariant.underlined => const UnderlineInputBorder(),
    RTextFieldVariant.outlined => const OutlineInputBorder(),
    RTextFieldVariant.filled => const UnderlineInputBorder(),
  };
  final filled = variant == RTextFieldVariant.filled;

  return TextField(
    controller: controller,
    focusNode: focusNode,
    enabled: enabled,
    showCursor: showCursor,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      hintText: placeholder,
      helperText: helperText,
      errorText: errorText,
      border: border,
      filled: filled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefix,
      suffix: suffix,
    ),
  );
}

Widget buildParityHarness({
  required Widget Function(BuildContext context) rendererBuilder,
  required Widget nativeField,
}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.0),
          devicePixelRatio: 1.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: rendererBuilder(context)),
                  const SizedBox(width: 16),
                  Expanded(child: nativeField),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget buildE2eParityHarness({
  required Widget headlessField,
  required Widget nativeField,
}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.0),
          devicePixelRatio: 1.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HeadlessThemeProvider(
                  theme: MaterialHeadlessTheme(),
                  child: headlessField,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: nativeField),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildRendererOnlyHarness({
  required Widget Function(BuildContext context) rendererBuilder,
}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.0),
          devicePixelRatio: 1.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(builder: rendererBuilder),
        ),
      ),
    ),
  );
}
