import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

typedef PhoneCountryMenuAnchorBuilder = Widget Function(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
  bool isOpen,
);

final class PhoneCountryMenuButton extends StatelessWidget {
  const PhoneCountryMenuButton({
    required this.request,
    required this.anchorBuilder,
    this.padding = EdgeInsets.zero,
    this.constraints = const BoxConstraints(
      minWidth: 44,
      minHeight: 32,
    ),
    super.key,
  });

  final RPhoneFieldCountryButtonRequest request;
  final PhoneCountryMenuAnchorBuilder anchorBuilder;
  final EdgeInsetsGeometry padding;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      child: IntrinsicWidth(
        child: Semantics(
          button: true,
          enabled: request.enabled,
          label:
              'Selected country ${request.country.countryName} ${request.country.formattedDialCode}',
          child: FocusableActionDetector(
            enabled: request.enabled,
            mouseCursor:
                request.enabled ? SystemMouseCursors.click : MouseCursor.defer,
            child: Opacity(
              opacity: request.enabled ? 1 : request.style.disabledOpacity,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: request.enabled ? request.onPressed : null,
                child: ConstrainedBox(
                  constraints: constraints,
                  child: Padding(
                    padding: padding,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: anchorBuilder(context, request, false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
