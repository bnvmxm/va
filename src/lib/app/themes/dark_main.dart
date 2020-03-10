import 'package:flutter/material.dart';

ThemeData themeCurrent = _themeDartMain;

final ThemeData _themeDartMain = ThemeData(
  accentColor: accent,
  primaryColor: primary,
  primaryColorDark: primaryMaterialColor[900],
  primarySwatch: primaryMaterialColor,
  backgroundColor: primaryMaterialColor[700],
  cardColor: primary,
);

const int _primaryColor = 0xff261c33;
const Color primary = Color(_primaryColor);
const MaterialColor primaryMaterialColor = MaterialColor(_primaryColor, <int, Color>{
  50: Color(0xffe9e8eb),
  100: Color(0xffbebbc2),
  200: Color(0xff938e99),
  300: Color(0xff676070),
  400: Color(0xff3c3347),
  500: primary,
  600: Color(0xff1e1629),
  700: Color(0xff17111f),
  800: Color(0xff0f0b14),
  900: Color(0xff00000d)
});

const Color accent = Color(0xffDB6F18);
const Color secondary = Color(0xff8e67a0);
const Color secondaryLight = Color(0xffbf95d1);
const Color secondaryDark = Color(0xff603c71);
