import 'package:flutter/material.dart';

class RAutocompleteRemoteMessageTile extends StatelessWidget {
  const RAutocompleteRemoteMessageTile({
    super.key,
    required this.message,
    required this.padding,
  });

  final String message;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

