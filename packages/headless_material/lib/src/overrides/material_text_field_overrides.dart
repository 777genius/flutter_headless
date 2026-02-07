import 'package:flutter/material.dart';

/// Preset-specific advanced overrides for Material text fields.
///
/// These knobs are opt-in and intentionally break strict Material-3 parity
/// when used. Prefer them for demos or app-specific styling that would
/// normally be expressed via `ThemeData.inputDecorationTheme`.
@immutable
final class MaterialTextFieldOverrides {
  const MaterialTextFieldOverrides({
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
  });

  /// Override `InputDecoration.filled`.
  final bool? filled;

  /// Override `InputDecoration.fillColor`.
  ///
  /// Note: in Material 3, the effective fill is still state-dependent due to
  /// `InputDecorator` hover blending.
  final Color? fillColor;

  /// Override `InputDecoration.contentPadding`.
  final EdgeInsetsGeometry? contentPadding;

  /// Override `InputDecoration.border`.
  final InputBorder? border;

  /// Override `InputDecoration.enabledBorder`.
  final InputBorder? enabledBorder;

  /// Override `InputDecoration.focusedBorder`.
  final InputBorder? focusedBorder;

  /// Override `InputDecoration.errorBorder`.
  final InputBorder? errorBorder;

  /// Override `InputDecoration.focusedErrorBorder`.
  final InputBorder? focusedErrorBorder;

  bool get hasOverrides =>
      filled != null ||
      fillColor != null ||
      contentPadding != null ||
      border != null ||
      enabledBorder != null ||
      focusedBorder != null ||
      errorBorder != null ||
      focusedErrorBorder != null;
}

