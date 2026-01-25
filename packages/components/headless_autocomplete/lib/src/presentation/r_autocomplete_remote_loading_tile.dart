import 'package:flutter/material.dart';

class RAutocompleteRemoteLoadingTile extends StatelessWidget {
  const RAutocompleteRemoteLoadingTile({
    super.key,
    required this.padding,
    this.loadingWidget,
  });

  final EdgeInsets padding;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Center(
        child: loadingWidget ??
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
      ),
    );
  }
}

