import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

Widget _raisedButton(
        {required BuildContext context,
        required VoidCallback onPressed,
        VoidCallback? onLongPress,
        required String text,
        Color? color,
        double? width,
        double? height,
        double? padding,
        Key? key}) =>
    ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          primary: color ?? VATheme.of(context).colorPrimary300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: SizedBox(
            width: width ?? 80,
            height: height ?? 40,
            child: Center(child: Text(text, key: key, style: VATheme.of(context).textButton))));

Widget raisedButtonDefault(
        {required BuildContext context,
        required VoidCallback onPressed,
        VoidCallback? onLongPress,
        required String text,
        bool isDestructive = false,
        double? width,
        double? height,
        double? padding,
        Key? key}) =>
    _raisedButton(
        context: context,
        onPressed: onPressed,
        onLongPress: onLongPress,
        text: text,
        color: isDestructive
            ? VATheme.of(context).colorAttention
            : VATheme.of(context).colorAccentVariant,
        width: width,
        height: height,
        padding: padding,
        key: key);

Widget raisedButtonNormal(
        {required BuildContext context,
        required VoidCallback onPressed,
        VoidCallback? onLongPress,
        required String text,
        double? width,
        double? height,
        double? padding,
        Key? key}) =>
    _raisedButton(
        context: context,
        onPressed: onPressed,
        onLongPress: onLongPress,
        text: text,
        width: width,
        height: height,
        padding: padding,
        key: key);
