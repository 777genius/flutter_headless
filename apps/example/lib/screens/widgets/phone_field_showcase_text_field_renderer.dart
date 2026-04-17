import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'phone_field_showcase_text_field_token_resolver.dart';

final class PhoneFieldShowcaseTextFieldRenderer implements RTextFieldRenderer {
  const PhoneFieldShowcaseTextFieldRenderer({
    this.fallbackTokenResolver = const PhoneFieldShowcaseTextFieldTokenResolver(),
  });

  final PhoneFieldShowcaseTextFieldTokenResolver fallbackTokenResolver;

  @override
  Widget render(RTextFieldRenderRequest request) {
    final tokens = request.resolvedTokens ??
        fallbackTokenResolver.resolve(
          context: request.context,
          spec: request.spec,
          states: request.state.toWidgetStates(),
          constraints: request.constraints,
          overrides: request.overrides,
        );

    return PhoneFieldShowcaseTextFieldSurface(
      request: request,
      tokens: tokens,
    );
  }
}

final class PhoneFieldShowcaseTextFieldSurface extends StatelessWidget {
  const PhoneFieldShowcaseTextFieldSurface({
    required this.request,
    required this.tokens,
    super.key,
  });

  final RTextFieldRenderRequest request;
  final RTextFieldResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    final message = request.spec.errorText ?? request.spec.helperText;
    final messageStyle = request.spec.errorText != null
        ? tokens.errorStyle.copyWith(color: tokens.errorColor)
        : tokens.helperStyle.copyWith(color: tokens.helperColor);

    return Opacity(
      opacity: request.state.isDisabled ? tokens.disabledOpacity : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (request.spec.label case final label?)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                label,
                style: tokens.labelStyle.copyWith(color: tokens.labelColor),
              ),
            ),
          _PhoneFieldShowcaseChrome(
            request: request,
            tokens: tokens,
          ),
          if (message case final resolvedMessage?)
            Padding(
              padding: EdgeInsets.only(top: tokens.messageSpacing),
              child: Text(resolvedMessage, style: messageStyle),
            ),
        ],
      ),
    );
  }
}

final class _PhoneFieldShowcaseChrome extends StatelessWidget {
  const _PhoneFieldShowcaseChrome({
    required this.request,
    required this.tokens,
  });

  final RTextFieldRenderRequest request;
  final RTextFieldResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final decoration = _PhoneFieldShowcaseDecoration(
          request: request,
          tokens: tokens,
        );
        Widget content = AnimatedContainer(
          duration: tokens.containerAnimationDuration,
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(
            minWidth: tokens.minSize.width,
            minHeight: tokens.minSize.height,
          ),
          padding: tokens.containerPadding,
          decoration: decoration.value,
          child: _PhoneFieldShowcaseRow(
            request: request,
            tokens: tokens,
          ),
        );

        if (constraints.hasBoundedWidth) {
          content = SizedBox(
            width: constraints.maxWidth,
            child: content,
          );
        }

        final commands = request.commands;
        if (commands?.tapContainer == null) {
          return content;
        }

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => commands!.tapContainer?.call(),
          child: content,
        );
      },
    );
  }
}

final class _PhoneFieldShowcaseDecoration {
  const _PhoneFieldShowcaseDecoration({
    required this.request,
    required this.tokens,
  });

  final RTextFieldRenderRequest request;
  final RTextFieldResolvedTokens tokens;

  BoxDecoration get value {
    if (request.spec.variant == RTextFieldVariant.underlined) {
      return BoxDecoration(
        border: _resolvedBottomBorder(),
      );
    }

    return BoxDecoration(
      color: tokens.containerBackgroundColor,
      borderRadius: tokens.containerBorderRadius,
      border: _resolvedOutlineBorder(),
      boxShadow: tokens.containerElevation > 0
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12 + tokens.containerElevation * 6,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
    );
  }

  Border? _resolvedBottomBorder() {
    if (!_showsBorder) {
      return null;
    }

    return Border(
      bottom: BorderSide(
        color: tokens.containerBorderColor,
        width: tokens.containerBorderWidth,
      ),
    );
  }

  BoxBorder? _resolvedOutlineBorder() {
    if (!_showsBorder) {
      return null;
    }

    return Border.all(
      color: tokens.containerBorderColor,
      width: tokens.containerBorderWidth,
    );
  }

  bool get _showsBorder {
    return tokens.containerBorderWidth > 0 &&
        tokens.containerBorderColor.a > 0;
  }
}

final class _PhoneFieldShowcaseRow extends StatelessWidget {
  const _PhoneFieldShowcaseRow({
    required this.request,
    required this.tokens,
  });

  final RTextFieldRenderRequest request;
  final RTextFieldResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    final slots = request.slots;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (slots?.leading case final leading?)
          Padding(
            padding: EdgeInsets.only(right: tokens.iconSpacing),
            child: leading,
          ),
        if (_isVisible(request.spec.prefixMode, request.state) &&
            slots?.prefix != null)
          Padding(
            padding: EdgeInsets.only(right: tokens.iconSpacing),
            child: slots!.prefix!,
          ),
        Expanded(
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.centerLeft,
            children: [
              if (request.spec.placeholder != null && !request.state.hasText)
                IgnorePointer(
                  child: Text(
                    request.spec.placeholder!,
                    style: tokens.placeholderStyle.copyWith(
                      color: tokens.placeholderColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              request.input,
            ],
          ),
        ),
        if (_isVisible(request.spec.suffixMode, request.state) &&
            slots?.suffix != null)
          Padding(
            padding: EdgeInsets.only(left: tokens.iconSpacing),
            child: slots!.suffix!,
          ),
        if (slots?.trailing case final trailing?)
          Padding(
            padding: EdgeInsets.only(left: tokens.iconSpacing),
            child: trailing,
          ),
      ],
    );
  }
}

bool _isVisible(
  RTextFieldOverlayVisibilityMode mode,
  RTextFieldState state,
) {
  return switch (mode) {
    RTextFieldOverlayVisibilityMode.never => false,
    RTextFieldOverlayVisibilityMode.whileEditing => state.isFocused,
    RTextFieldOverlayVisibilityMode.notEditing => !state.isFocused,
    RTextFieldOverlayVisibilityMode.always => true,
  };
}
