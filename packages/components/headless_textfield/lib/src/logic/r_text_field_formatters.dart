import 'package:flutter/services.dart';

/// Builds the effective list of input formatters for a text field.
///
/// Handles maxLength enforcement by adding [LengthLimitingTextInputFormatter]
/// only if needed (no user-provided limiter).
final class RTextFieldFormatters {
  const RTextFieldFormatters._();

  /// Build effective formatters list, adding length limiter if needed.
  ///
  /// If [maxLength] is not null and [inputFormatters] does not already
  /// contain a [LengthLimitingTextInputFormatter], one will be added.
  static List<TextInputFormatter>? build({
    required List<TextInputFormatter>? inputFormatters,
    required int? maxLength,
    required MaxLengthEnforcement? maxLengthEnforcement,
  }) {
    if (maxLength == null) {
      return inputFormatters;
    }

    // Check if user already provided a length limiter
    final hasUserLimiter = inputFormatters?.any(
          (f) => f is LengthLimitingTextInputFormatter,
        ) ??
        false;

    if (hasUserLimiter) {
      return inputFormatters;
    }

    // Add length limiter
    final lengthLimiter = LengthLimitingTextInputFormatter(
      maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
    );

    if (inputFormatters == null || inputFormatters.isEmpty) {
      return [lengthLimiter];
    }

    return [...inputFormatters, lengthLimiter];
  }
}
