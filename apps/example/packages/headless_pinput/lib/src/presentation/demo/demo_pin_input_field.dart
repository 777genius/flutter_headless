import 'package:flutter/material.dart';

import '../../contracts/r_pin_input_renderer.dart';
import '../../contracts/r_pin_input_resolved_tokens.dart';
import 'demo_pin_input_cells_row.dart';

final class DemoPinInputField extends StatelessWidget {
  const DemoPinInputField({
    super.key,
    required this.request,
    required this.tokens,
  });

  final RPinInputRenderRequest request;
  final RPinInputResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    final fieldWidth = (tokens.defaultCell.size.width * request.cells.length) +
        (tokens.cellGap * (request.cells.length - 1));
    final fieldHeight = _maxCellHeight();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: fieldWidth,
          height: fieldHeight,
          child: Stack(
            children: [
              Positioned.fill(child: request.hiddenInput),
              Positioned.fill(
                child: ExcludeSemantics(
                  child: IgnorePointer(
                    child: DemoPinInputCellsRow(
                      request: request,
                      tokens: tokens,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (request.visibleErrorText case final errorText?)
          Padding(
            padding: EdgeInsets.only(top: tokens.errorTopSpacing),
            child: Text(
              errorText,
              style: tokens.errorStyle.copyWith(color: tokens.errorColor),
            ),
          ),
      ],
    );
  }

  double _maxCellHeight() {
    final allTokens = [
      tokens.defaultCell,
      tokens.focusedCell,
      tokens.submittedCell,
      tokens.followingCell,
      tokens.disabledCell,
      tokens.errorCell,
    ];
    return allTokens
        .map((cellTokens) => cellTokens.size.height)
        .reduce((value, element) => value > element ? value : element);
  }
}
