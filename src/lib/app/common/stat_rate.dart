import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class StatRate extends StatelessWidget {
  const StatRate(this.rate, {this.size = 16});

  final int rate;
  final double size;

  @override
  Widget build(BuildContext context) {
    final str = rate.isRateLow()
        ? Translations.of(context).labels.StatRateLearning
        : rate.isRateHigh()
            ? Translations.of(context).labels.StatRateLearned
            : Translations.of(context).labels.StatRateReviewing;
    final style = rate.isRateHigh()
        ? VATheme.of(context).textAccentSubtitle1
        : VATheme.of(context).textSubtitle1;

    return Text(str, style: style);
  }
}
