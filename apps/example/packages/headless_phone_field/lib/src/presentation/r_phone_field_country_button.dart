import 'package:flutter/material.dart';

import '../contracts/r_phone_field_types.dart';

final class DefaultRPhoneFieldCountryButton extends StatelessWidget {
  const DefaultRPhoneFieldCountryButton({
    super.key,
    required this.request,
  });

  final RPhoneFieldCountryButtonRequest request;

  @override
  Widget build(BuildContext context) {
    final style = request.style;
    final textStyle = style.textStyle ?? DefaultTextStyle.of(context).style;
    final children = <Widget>[
      if (style.showFlag && request.country.flagEmoji.isNotEmpty)
        Text(request.country.flagEmoji, style: textStyle),
      if (style.showIsoCode)
        Text(request.country.isoCode.name, style: textStyle),
      if (style.showDialCode && request.country.formattedDialCode.isNotEmpty)
        Text(request.country.formattedDialCode, style: textStyle),
      if (style.showDropdownIcon)
        Icon(
          Icons.arrow_drop_down,
          size: style.dropdownIconSize,
          color: style.dropdownIconColor,
        ),
    ];
    final visibleChildren = children.isEmpty
        ? [Text(request.country.isoCode.name, style: textStyle)]
        : children;

    return ExcludeFocus(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Semantics(
          button: true,
          enabled: request.enabled,
          label:
              'Selected country ${request.country.countryName} ${request.country.formattedDialCode}',
          child: Opacity(
            opacity: request.enabled ? 1 : style.disabledOpacity,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: request.enabled ? request.onPressed : null,
              child: Padding(
                padding: style.padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _withSpacing(visibleChildren, gap: style.spacing),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> children, {required double gap}) {
    if (children.length < 2) return children;
    return [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(width: gap),
        children[i],
      ],
    ];
  }
}
