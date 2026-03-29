import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'cupertino_button_parity_constants.dart';

CupertinoButtonSize mapCupertinoButtonSize(RButtonSize size) {
  switch (size) {
    case RButtonSize.small:
      return CupertinoButtonSize.small;
    case RButtonSize.medium:
      return CupertinoButtonSize.medium;
    case RButtonSize.large:
      return CupertinoButtonSize.large;
  }
}

double cupertinoButtonMinHeight(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallMinHeight;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumMinHeight;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargeMinHeight;
  }
}

EdgeInsetsGeometry cupertinoButtonPadding(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallPadding;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumPadding;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargePadding;
  }
}

double cupertinoButtonBorderRadius(CupertinoButtonSize sizeStyle) {
  switch (sizeStyle) {
    case CupertinoButtonSize.small:
      return CupertinoButtonParityConstants.kSmallBorderRadius;
    case CupertinoButtonSize.medium:
      return CupertinoButtonParityConstants.kMediumBorderRadius;
    case CupertinoButtonSize.large:
      return CupertinoButtonParityConstants.kLargeBorderRadius;
  }
}
