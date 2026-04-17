import 'package:flutter/widgets.dart';

import '../../contracts/r_pin_input_renderer.dart';
import '../../contracts/r_pin_input_resolved_tokens.dart';
import 'demo_pin_input_cell.dart';

final class DemoPinInputCellsRow extends StatelessWidget {
  const DemoPinInputCellsRow({
    super.key,
    required this.request,
    required this.tokens,
  });

  final RPinInputRenderRequest request;
  final RPinInputResolvedTokens tokens;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < request.cells.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: tokens.cellGap));
      }
      final cell = request.cells[i];
      children.add(
        DemoPinInputCellView(
          key: ValueKey('pin-cell-${cell.index}'),
          spec: request.spec,
          cell: cell,
          resolvedTokens: tokens,
          tokens: tokens.cellTokensFor(cell.state),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
