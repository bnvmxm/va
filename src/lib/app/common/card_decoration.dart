import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

Decoration cardDecoration(BuildContext context) => BoxDecoration(
    color: VATheme.of(context).colorBackgroundCard,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(width: 0, color: VATheme.of(context).colorBackgroundCard));
