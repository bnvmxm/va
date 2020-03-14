import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class StatTarget extends StatelessWidget {
  const StatTarget(this.diff, {this.size = 16, this.textStyle});

  final Duration diff;
  final double size;
  final TextStyle textStyle;

  Icon getIcon(BuildContext context) => diff.isTargetFar()
      ? Icon(Icons.assignment_turned_in, color: VATheme.of(context).colorAccentVariant, size: size)
      : diff.isTargetClose()
          ? Icon(Icons.assignment_late, color: VATheme.of(context).colorAttention, size: size)
          : Icon(Icons.assignment, size: size);

  @override
  Widget build(BuildContext context) {
    final target = diff.toStringAsTarget();
    return Row(children: [
      getIcon(context),
      if (target.isNotEmpty) const SizedBox(width: 4),
      if (target.isNotEmpty)
        Text(target,
            style: diff.isTargetFar()
                ? VATheme.of(context).textAccentCaption
                : diff.isTargetClose()
                    ? VATheme.of(context).textAttentionCaption
                    : VATheme.of(context).textCaption)
    ]);
  }
}
