import 'package:flutter/material.dart';

Decoration cardDecoration(BuildContext context,
        [double borderWidth = 1.0, Color borderColor, Color cardColor]) =>
    BoxDecoration(
        color: cardColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border:
            Border.all(width: borderWidth, color: borderColor ?? Theme.of(context).dividerColor));
