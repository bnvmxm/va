import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

BorderRadiusGeometry get borderRadius => BorderRadius.circular(8.0);

Decoration cardDecoration(BuildContext context,
        {bool mainBackgroundColor = false}) =>
    BoxDecoration(
        color: mainBackgroundColor
            ? VATheme.of(context).colorBackgroundMain
            : VATheme.of(context).colorBackgroundCard,
        borderRadius: borderRadius,
        border: Border.all(
            width: 0,
            color: mainBackgroundColor
                ? VATheme.of(context).colorBackgroundMain
                : VATheme.of(context).colorBackgroundCard));
