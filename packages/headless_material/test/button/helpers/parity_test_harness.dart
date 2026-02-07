import 'package:flutter/material.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

const _kContentPadding = EdgeInsets.all(16);

Widget buildE2eParityHarness({
  required Widget headlessButton,
  required Widget nativeButton,
}) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.0),
          devicePixelRatio: 1.0,
        ),
        child: Padding(
          padding: _kContentPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HeadlessThemeProvider(
                  theme: MaterialHeadlessTheme(),
                  child: Center(child: headlessButton),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: nativeButton),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildRendererParityHarness({
  required Widget Function(BuildContext context) rendererBuilder,
  required Widget nativeButton,
}) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.0),
          devicePixelRatio: 1.0,
        ),
        child: Padding(
          padding: _kContentPadding,
          child: Builder(
            builder: (context) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: rendererBuilder(context)),
                  const SizedBox(width: 16),
                  Expanded(child: nativeButton),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget buildNativeMaterialButton({
  required RButtonVariant variant,
  required bool enabled,
  required Widget child,
  MaterialTapTargetSize? tapTargetSize,
  WidgetStatesController? statesController,
  FocusNode? focusNode,
}) {
  final onPressed = enabled ? () {} : null;
  final style = tapTargetSize != null
      ? ButtonStyle(tapTargetSize: tapTargetSize)
      : null;

  final button = switch (variant) {
    RButtonVariant.filled => FilledButton(
        onPressed: onPressed,
        style: style,
        statesController: statesController,
        focusNode: focusNode,
        child: child,
      ),
    RButtonVariant.tonal => FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        statesController: statesController,
        focusNode: focusNode,
        child: child,
      ),
    RButtonVariant.outlined => OutlinedButton(
        onPressed: onPressed,
        style: style,
        statesController: statesController,
        focusNode: focusNode,
        child: child,
      ),
    RButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: style,
        statesController: statesController,
        focusNode: focusNode,
        child: child,
      ),
  };

  return ExcludeSemantics(
    child: AbsorbPointer(
      absorbing: true,
      child: button,
    ),
  );
}

Widget buildHeadlessButton({
  required RButtonVariant variant,
  required bool enabled,
  required Widget child,
}) {
  return RTextButton(
    onPressed: enabled ? () {} : null,
    variant: variant,
    size: RButtonSize.medium,
    child: child,
  );
}

