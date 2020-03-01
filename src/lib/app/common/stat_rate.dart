import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class StatRate extends StatelessWidget {
  const StatRate(this.rate, {this.size = 16, this.textStyle});

  final int rate;
  final double size;
  final TextStyle textStyle;

  TextStyle getTextStyle(BuildContext context) => textStyle ?? Theme.of(context).textTheme.caption;

  @override
  Widget build(BuildContext context) {
    final str = rate.toStringAsRate();
    final style = rate.isRateHigh()
        ? getTextStyle(context).copyWith(color: Theme.of(context).accentColor)
        : getTextStyle(context);

    return Text(str, style: style);
  }
}
