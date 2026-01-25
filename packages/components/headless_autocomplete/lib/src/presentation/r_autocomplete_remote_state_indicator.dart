import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_remote_state.dart';
import 'r_autocomplete_remote_error_tile.dart';
import 'r_autocomplete_remote_loading_tile.dart';
import 'r_autocomplete_remote_message_tile.dart';

class RAutocompleteRemoteStateIndicator extends StatelessWidget {
  const RAutocompleteRemoteStateIndicator({
    super.key,
    required this.features,
    this.onRetry,
    this.loadingWidget,
    this.idleMessage = 'Type to search...',
    this.emptyMessage = 'No results found',
    this.errorMessagePrefix = 'Error: ',
    this.retryButtonText = 'Retry',
    this.padding = const EdgeInsets.all(16),
  });

  final HeadlessRequestFeatures features;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
  final String idleMessage;
  final String emptyMessage;
  final String errorMessagePrefix;
  final String retryButtonText;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final remoteState = features.get(rAutocompleteRemoteStateKey);
    if (remoteState == null) {
      return RAutocompleteRemoteMessageTile(
        message: emptyMessage,
        padding: padding,
      );
    }

    return switch (remoteState.status) {
      RAutocompleteRemoteStatus.idle => RAutocompleteRemoteMessageTile(
          message: idleMessage,
          padding: padding,
        ),
      RAutocompleteRemoteStatus.loading => RAutocompleteRemoteLoadingTile(
          padding: padding,
          loadingWidget: loadingWidget,
        ),
      RAutocompleteRemoteStatus.ready => RAutocompleteRemoteMessageTile(
          message: emptyMessage,
          padding: padding,
        ),
      RAutocompleteRemoteStatus.error => RAutocompleteRemoteErrorTile(
          state: remoteState,
          padding: padding,
          onRetry: onRetry,
          errorMessagePrefix: errorMessagePrefix,
          retryButtonText: retryButtonText,
        ),
    };
  }
}
