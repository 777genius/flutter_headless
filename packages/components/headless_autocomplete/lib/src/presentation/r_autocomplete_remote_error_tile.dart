import 'package:flutter/material.dart';

import '../sources/r_autocomplete_remote_state.dart';

class RAutocompleteRemoteErrorTile extends StatelessWidget {
  const RAutocompleteRemoteErrorTile({
    super.key,
    required this.state,
    required this.padding,
    required this.errorMessagePrefix,
    required this.retryButtonText,
    this.onRetry,
  });

  final RAutocompleteRemoteState state;
  final EdgeInsets padding;
  final String errorMessagePrefix;
  final String retryButtonText;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMessage = state.error?.message;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            errorMessage != null
                ? '$errorMessagePrefix$errorMessage'
                : errorMessagePrefix.replaceAll(': ', ''),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          if (onRetry != null && state.canRetry) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(retryButtonText),
            ),
          ],
        ],
      ),
    );
  }
}

