import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

final class PhoneFieldNavigatorMenuLauncher extends StatefulWidget {
  const PhoneFieldNavigatorMenuLauncher({
    required this.value,
    required this.navigator,
    required this.countries,
    required this.favoriteCountries,
    required this.onCountrySelected,
    super.key,
  });

  final PhoneNumber value;
  final RPhoneFieldCountrySelectorNavigator navigator;
  final List<IsoCode> countries;
  final List<IsoCode> favoriteCountries;
  final ValueChanged<IsoCode> onCountrySelected;

  @override
  State<PhoneFieldNavigatorMenuLauncher> createState() =>
      _PhoneFieldNavigatorMenuLauncherState();
}

class _PhoneFieldNavigatorMenuLauncherState
    extends State<PhoneFieldNavigatorMenuLauncher> {
  final _buttonKey = GlobalKey();
  final _focusNode = FocusNode(debugLabel: 'PhoneFieldNavigatorMenuLauncher');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openSelector() async {
    final selected = await widget.navigator.show(
      context,
      RPhoneFieldCountrySelectorRequest(
        countries: widget.countries,
        favoriteCountries: widget.favoriteCountries,
        selectedCountry: widget.value.isoCode,
        showDialCode: true,
        noResultMessage: null,
        searchAutofocus: widget.navigator.searchAutofocus,
        subtitleStyle: null,
        titleStyle: null,
        searchBoxDecoration: null,
        searchBoxTextStyle: null,
        searchBoxIconColor: null,
        scrollPhysics: null,
        backgroundColor: widget.navigator.backgroundColor,
        flagSize: 40,
        anchorRectGetter: _anchorRect,
        restoreFocusNode: _focusNode,
        useRootNavigator: widget.navigator.useRootNavigator,
      ),
    );
    if (!mounted || selected == null) return;
    widget.onCountrySelected(selected);
  }

  Rect? _anchorRect() {
    final renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;
    return renderBox.localToGlobal(Offset.zero) & renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        );
    final hintStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        key: _buttonKey,
        child: Material(
          color: Colors.transparent,
          key: const ValueKey('phone-field-country-launcher'),
          child: InkWell(
            focusNode: _focusNode,
            onTap: _openSelector,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.48),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_rounded, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.value.isoCode.name}  + ${widget.value.countryCode}',
                    style: labelStyle,
                  ),
                  const SizedBox(width: 10),
                  Text('Inline search menu', style: hintStyle),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
