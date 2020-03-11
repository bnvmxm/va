part of 'va_theme.dart';

final _specs = <VAThemeId, VAThemeSpecification>{
  VAThemeId.darkCold: VAColdDarkThemeSpecification(),
  VAThemeId.light: VALightThemeSpecification()
};

extension VAThemeIdExt on VAThemeId {
  ColorScheme getMaterialColorScheme() {
    return const ColorScheme.dark().copyWith(
        brightness: Brightness.dark,
        background: _specs[this].colorPrimary,
        error: _specs[this].colorAccent,
        primary: _specs[this].colorPrimary,
        primaryVariant: _specs[this].colorPrimaryLight,
        secondary: _specs[this].colorSecondary,
        secondaryVariant: _specs[this].colorSecondaryVariant,
        surface: _specs[this].colorPrimaryDark);
  }

  MaterialColor getMaterialColorSwatch() {
    return MaterialColor(_specs[this].colorPrimary500.value, <int, Color>{
      50: _specs[this].colorPrimary050,
      100: _specs[this].colorPrimary100,
      200: _specs[this].colorPrimary200,
      300: _specs[this].colorPrimary300,
      400: _specs[this].colorPrimary400,
      500: _specs[this].colorPrimary500,
      600: _specs[this].colorPrimary600,
      700: _specs[this].colorPrimary700,
      800: _specs[this].colorPrimary800,
      900: _specs[this].colorPrimary900
    });
  }

  ThemeData getMaterialThemeData() {
    final cs = getMaterialColorScheme();
    final swatch = getMaterialColorSwatch();

    return ThemeData(
        brightness: Brightness.dark,
        colorScheme: cs,
        primarySwatch: swatch,
        accentColor: _specs[this].colorAccent,
        primaryColor: cs.primary,
        primaryColorLight: _specs[this].colorPrimaryLight,
        primaryColorDark: _specs[this].colorPrimaryDark,
        cardColor: cs.primary,
        backgroundColor: _specs[this].colorPrimaryDark,
        canvasColor: _specs[this].colorPrimaryDark,
        dialogBackgroundColor: _specs[this].colorPrimaryDark,
        scaffoldBackgroundColor: _specs[this].colorPrimaryDark,
        secondaryHeaderColor: _specs[this].colorPrimary050,
        dividerColor: _specs[this].colorPrimaryLight,
        splashColor: _specs[this].colorPrimaryLight);
  }
}
