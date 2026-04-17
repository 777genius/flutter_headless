import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_material/headless_material.dart';

import '../../theme_mode_scope.dart';

RenderOverrides compactPhoneFieldOverrides(BuildContext context) {
  final isCupertino = ThemeModeScope.of(context).isCupertino;

  return RenderOverrides({
    RTextFieldOverrides: const RTextFieldOverrides.tokens(
      containerPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      iconSpacing: 5,
    ),
    if (isCupertino)
      CupertinoTextFieldOverrides: const CupertinoTextFieldOverrides(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      )
    else
      MaterialTextFieldOverrides: const MaterialTextFieldOverrides(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
  });
}
