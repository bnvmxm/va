import 'package:flutter/material.dart';

ThemeData themeCurrent = _themeDartMain;

final ThemeData _themeDartMain = ThemeData(
    brightness: _colorsScheme.brightness,
    colorScheme: _colorsScheme,
    accentColor: accent,
    primaryColor: _colorsScheme.primary,
    primaryColorLight: _colorsScheme.primaryVariant,
    primaryColorDark: primaryDark,
    primarySwatch: _primaryMaterialColor,
    cardColor: primary,
    backgroundColor: _colorsScheme.surface,
    canvasColor: _colorsScheme.surface,
    dialogBackgroundColor: _colorsScheme.surface,
    scaffoldBackgroundColor: _colorsScheme.surface,
    secondaryHeaderColor: _primaryMaterialColor[100],
    dividerColor: primaryLight,
    splashColor: primaryLight);

const int _primaryColor = 0xff261c33;
const MaterialColor _primaryMaterialColor = MaterialColor(_primaryColor, <int, Color>{
  50: Color(0xffe9e8eb),
  100: Color(0xffbebbc2),
  200: Color(0xff938e99),
  300: primaryLight,
  400: Color(0xff3c3347),
  500: primary,
  600: Color(0xff1e1629),
  700: Color(0xff17111f),
  800: Color(0xff0f0b14),
  900: Color(0xff00000d)
});

const Color primary = Color(_primaryColor);
const Color primaryLight = Color(0xff676070);
const Color primaryDark = Color(0xff17111f);

const Color accent = Color(0xffDB6F18);

const Color secondary = Color(0xff8e67a0);
const Color secondaryVariant = Color(0xff603c71);

final _colorsScheme = const ColorScheme.dark().copyWith(
    brightness: Brightness.dark,
    background: _primaryMaterialColor[600],
    error: accent,
    primary: primary,
    primaryVariant: primaryLight,
    secondary: secondary,
    secondaryVariant: secondaryVariant,
    surface: _primaryMaterialColor[600]);
