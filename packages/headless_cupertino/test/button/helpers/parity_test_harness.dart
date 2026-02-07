import 'package:flutter/cupertino.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_theme/headless_theme.dart';

const _kContentPadding = EdgeInsets.all(16);

Widget buildE2eParityHarness({
  required Widget headlessButton,
  required Widget nativeButton,
}) {
  return CupertinoApp(
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.activeBlue,
    ),
    debugShowCheckedModeBanner: false,
    home: CupertinoPageScaffold(
      child: MediaQuery(
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
                  theme: CupertinoHeadlessTheme(),
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
  return CupertinoApp(
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.activeBlue,
    ),
    debugShowCheckedModeBanner: false,
    home: CupertinoPageScaffold(
      child: MediaQuery(
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

CupertinoButtonSize _mapSizeStyle(RButtonSize size) {
  switch (size) {
    case RButtonSize.small:
      return CupertinoButtonSize.small;
    case RButtonSize.medium:
      return CupertinoButtonSize.medium;
    case RButtonSize.large:
      return CupertinoButtonSize.large;
  }
}

Widget buildNativeCupertinoButton({
  required RButtonVariant variant,
  required RButtonSize size,
  required bool enabled,
  required Key key,
  required Widget child,
  FocusNode? focusNode,
  bool absorbPointer = true,
}) {
  final onPressed = enabled ? () {} : null;
  final sizeStyle = _mapSizeStyle(size);

  final Widget button = switch (variant) {
    RButtonVariant.filled => CupertinoButton.filled(
        key: key,
        onPressed: onPressed,
        focusNode: focusNode,
        sizeStyle: sizeStyle,
        child: child,
      ),
    RButtonVariant.tonal => CupertinoButton.tinted(
        key: key,
        onPressed: onPressed,
        focusNode: focusNode,
        sizeStyle: sizeStyle,
        child: child,
      ),
    RButtonVariant.text => CupertinoButton(
        key: key,
        onPressed: onPressed,
        focusNode: focusNode,
        sizeStyle: sizeStyle,
        child: child,
      ),
    RButtonVariant.outlined => throw StateError(
        'No native Cupertino outlined button. '
        'Use renderer-only tests for RButtonVariant.outlined.',
      ),
  };

  Widget result = ExcludeSemantics(child: button);
  if (absorbPointer) {
    result = AbsorbPointer(absorbing: true, child: result);
  }
  return result;
}

Widget buildHeadlessButton({
  required RButtonVariant variant,
  required RButtonSize size,
  required bool enabled,
  required Widget child,
}) {
  return RTextButton(
    onPressed: enabled ? () {} : null,
    variant: variant,
    size: size,
    child: child,
  );
}
