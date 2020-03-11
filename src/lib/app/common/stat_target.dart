import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class StatTarget extends StatelessWidget {
  const StatTarget(this.diff, {this.size = 16, this.textStyle});

  final Duration diff;
  final double size;
  final TextStyle textStyle;

  Color getColor(BuildContext context) => diff.isTargetClose()
      ? VATheme.of(context).colorAccentVariant
      : VATheme.of(context).colorForeground;

  IconData getIcon() => diff.isTargetFar()
      ? Icons.assignment_turned_in
      : diff.isTargetClose() ? Icons.assignment_late : Icons.assignment;

  TextStyle getTextStyle(BuildContext context) => textStyle ?? Theme.of(context).textTheme.caption;
  TextStyle getTextStyleWithColor(BuildContext context) =>
      getTextStyle(context).copyWith(color: getColor(context));

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(
          getIcon(),
          color: getColor(context),
          size: size,
        ),
        const SizedBox(width: 4),
        Text(diff.toStringAsTarget(), style: getTextStyleWithColor(context))
      ]);
}
