import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import 'menu_country_selector_overlay.dart';

class RPhoneFieldMenuCountrySelectorNavigator
    implements RPhoneFieldCountrySelectorNavigator {
  const RPhoneFieldMenuCountrySelectorNavigator({
    this.height,
    this.searchAutofocus = true,
    this.backgroundColor,
    this.anchorTarget = RPhoneFieldMenuAnchorTarget.trigger,
    this.useRootNavigator = false,
  });

  final double? height;
  @override
  final bool searchAutofocus;
  @override
  final Color? backgroundColor;
  final RPhoneFieldMenuAnchorTarget anchorTarget;
  @override
  final bool useRootNavigator;

  @override
  Future<IsoCode?> show(
    BuildContext context,
    RPhoneFieldCountrySelectorRequest request,
  ) async {
    final anchorRectGetter = _resolveAnchorRectGetter(request);
    if (anchorRectGetter == null) {
      return Future<IsoCode?>.value(null);
    }

    final selected = await showGeneralDialog<IsoCode?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss country selector',
      barrierColor: Colors.transparent,
      useRootNavigator: useRootNavigator,
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _PhoneFieldCountryMenuRoute(
          request: request,
          anchorRectGetter: anchorRectGetter,
          height: height ?? 360,
          backgroundColor: backgroundColor ?? request.backgroundColor,
          searchAutofocus: searchAutofocus,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(opacity: curved, child: child);
      },
    );

    return selected;
  }

  Rect? Function()? _resolveAnchorRectGetter(
    RPhoneFieldCountrySelectorRequest request,
  ) {
    return switch (anchorTarget) {
      RPhoneFieldMenuAnchorTarget.trigger =>
        request.triggerRectGetter ?? request.anchorRectGetter,
      RPhoneFieldMenuAnchorTarget.field => request.fieldRectGetter ??
          request.triggerRectGetter ??
          request.anchorRectGetter,
    };
  }
}

final class _PhoneFieldCountryMenuRoute extends StatefulWidget {
  const _PhoneFieldCountryMenuRoute({
    required this.request,
    required this.anchorRectGetter,
    required this.height,
    required this.backgroundColor,
    required this.searchAutofocus,
  });

  final RPhoneFieldCountrySelectorRequest request;
  final Rect? Function() anchorRectGetter;
  final double height;
  final Color? backgroundColor;
  final bool searchAutofocus;

  @override
  State<_PhoneFieldCountryMenuRoute> createState() =>
      _PhoneFieldCountryMenuRouteState();
}

class _PhoneFieldCountryMenuRouteState
    extends State<_PhoneFieldCountryMenuRoute> {
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode(debugLabel: 'PhoneCountryMenuSearch');
    if (widget.searchAutofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_searchFocusNode.canRequestFocus) return;
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = constraints.biggest;
          final anchorRect = widget.anchorRectGetter() ?? Rect.zero;
          final menuWidth = _resolveMenuWidth(
            anchorRect: anchorRect,
            viewportWidth: viewport.width,
          );
          final menuHeight = math.min(widget.height, viewport.height - 24);
          final menuOffset = _resolveMenuOffset(
            anchorRect: anchorRect,
            viewportSize: viewport,
            menuSize: Size(menuWidth, menuHeight),
          );

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
              Positioned(
                left: menuOffset.dx,
                top: menuOffset.dy,
                child: RPhoneFieldCountryMenuOverlay(
                  request: widget.request,
                  searchFocusNode: _searchFocusNode,
                  width: menuWidth,
                  height: menuHeight,
                  backgroundColor: widget.backgroundColor,
                  onCountrySelected: (country) {
                    Navigator.of(context).pop(country);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _resolveMenuWidth({
    required Rect anchorRect,
    required double viewportWidth,
  }) {
    const minWidth = 320.0;
    const horizontalMargin = 12.0;
    final availableWidth = viewportWidth - horizontalMargin * 2;
    final targetWidth = math.max(minWidth, anchorRect.width);
    return targetWidth.clamp(minWidth, availableWidth);
  }

  Offset _resolveMenuOffset({
    required Rect anchorRect,
    required Size viewportSize,
    required Size menuSize,
  }) {
    const margin = 12.0;
    final left = anchorRect.left.clamp(
      margin,
      viewportSize.width - menuSize.width - margin,
    );
    final fitsBelow =
        anchorRect.bottom + menuSize.height <= viewportSize.height - margin;
    final top = fitsBelow
        ? anchorRect.bottom
        : math.max(margin, anchorRect.top - menuSize.height);

    return Offset(left, top);
  }
}
