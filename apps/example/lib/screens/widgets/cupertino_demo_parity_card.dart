import 'package:flutter/cupertino.dart';

import 'cupertino_demo_scope.dart';

class CupertinoDemoParityCard extends StatelessWidget {
  const CupertinoDemoParityCard({
    required this.title,
    required this.caption,
    required this.child,
    super.key,
  });

  final String title;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoDemoScope(
      child: Builder(
        builder: (context) {
          final background = CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemGroupedBackground,
            context,
          );
          final border = CupertinoDynamicColor.resolve(
            CupertinoColors.separator,
            context,
          );
          final primary = CupertinoDynamicColor.resolve(
            CupertinoColors.label,
            context,
          );
          final secondary = CupertinoDynamicColor.resolve(
            CupertinoColors.secondaryLabel,
            context,
          );

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(
                        color: primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  caption,
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: secondary,
                            fontSize: 15,
                            height: 1.35,
                          ),
                ),
                const SizedBox(height: 18),
                child,
              ],
            ),
          );
        },
      ),
    );
  }
}

class CupertinoDemoParityLabel extends StatelessWidget {
  const CupertinoDemoParityLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.activeBlue,
              context,
            ),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
    );
  }
}
