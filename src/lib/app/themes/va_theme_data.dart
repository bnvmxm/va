import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

final _themes = <VAThemeId, VAThemeSpecification>{
  VAThemeId.darkCold: VAColdDarkThemeSpecification(),
  VAThemeId.light: VALightThemeSpecification()
};

ColorScheme _getColorScheme(VAThemeId themeId) =>
    themeId == VAThemeId.darkCold ? ColorScheme.dark() : ColorScheme.light();

Brightness _getBrightness(VAThemeId themeId) =>
    themeId == VAThemeId.darkCold ? Brightness.dark : Brightness.light;

ColorScheme _getMaterialColorScheme(VAThemeId themeId) => _getColorScheme(themeId).copyWith(
    brightness: _getBrightness(themeId),
    background: _themes[themeId]!.colorBackgroundMain,
    error: _themes[themeId]!.colorAttention,
    primary: _themes[themeId]!.colorPrimary500,
    primaryVariant: _themes[themeId]!.colorPrimary700,
    secondary: _themes[themeId]!.colorSecondary,
    secondaryVariant: _themes[themeId]!.colorSecondaryVariant,
    surface: _themes[themeId]!.colorBackgroundMain);

MaterialColor _getMaterialColorSwatch(VAThemeId themeId) =>
    MaterialColor(_themes[themeId]!.colorPrimary500.value, <int, Color>{
      50: _themes[themeId]!.colorPrimary050,
      100: _themes[themeId]!.colorPrimary100,
      200: _themes[themeId]!.colorPrimary200,
      300: _themes[themeId]!.colorPrimary300,
      400: _themes[themeId]!.colorPrimary400,
      500: _themes[themeId]!.colorPrimary500,
      600: _themes[themeId]!.colorPrimary600,
      700: _themes[themeId]!.colorPrimary700,
      800: _themes[themeId]!.colorPrimary800,
      900: _themes[themeId]!.colorPrimary900
    });

ThemeData getMaterialThemeData(VAThemeId themeId) {
  final cs = _getMaterialColorScheme(themeId);
  final th = _themes[themeId]!;
  final texts = TextTheme(
    headline1: th.textHeadline1,
    headline2: th.textHeadline2,
    headline3: th.textHeadline3,
    headline4: th.textHeadline4,
    headline5: th.textHeadline5,
    headline6: th.textHeadline6,
    subtitle1: th.textSubtitle1,
    subtitle2: th.textSubtitle2,
    bodyText1: th.textBodyText1,
    bodyText2: th.textBodyText2,
    caption: th.textCaption,
    button: th.textButton,
  );

  return ThemeData(
      colorScheme: cs,
      brightness: cs.brightness,
      primarySwatch: _getMaterialColorSwatch(themeId),
      primaryColor: cs.primary,
      primaryColorLight: th.colorPrimary300,
      primaryColorDark: th.colorPrimary700,
      cardColor: th.colorBackgroundCard,
      backgroundColor: th.colorBackgroundMain,
      canvasColor: th.colorBackgroundMain,
      dialogBackgroundColor: th.colorBackgroundMain,
      scaffoldBackgroundColor: th.colorBackgroundMain,
      secondaryHeaderColor: th.colorTextAccent,
      dividerColor: th.colorPrimary700,
      splashColor: th.colorBackgroundMain,
      toggleableActiveColor: th.colorTextAccent,
      appBarTheme: AppBarTheme(
        backgroundColor: th.colorBackgroundCard,
        iconTheme: IconThemeData(color: th.colorForegroundIconUnselected),
      ),
      popupMenuTheme: PopupMenuThemeData(
        textStyle: texts.subtitle1,
      ),
      selectedRowColor: th.colorBackgroundIconSelected,
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: th.colorBackgroundIconSelected, width: 1.0))),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: th.colorTextCursor, selectionHandleColor: th.colorTextCursor),
      primaryIconTheme: IconThemeData(color: th.colorBackgroundIconUnselected),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: th.colorForegroundIconSelected,
          backgroundColor: th.colorBackgroundIconSelected),
      textTheme: texts);
}
