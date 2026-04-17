import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

RenderOverrides phoneFieldShowcasePreviewOverrides() {
  return const RenderOverrides({
    RTextFieldOverrides: RTextFieldOverrides.tokens(
      containerPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      iconSpacing: 8,
      minSize: Size(0, 42),
    ),
  });
}
