part of 'va_theme.dart';

final _specs = <VAThemeId, VAThemeSpecification>{
  VAThemeId.darkCold: VAColdDarkThemeSpecification(),
  VAThemeId.light: VALightThemeSpecification()
};

extension VAThemeIdExt on VAThemeId {
  ColorScheme getMaterialColorScheme() {
    return const ColorScheme.dark().copyWith(
        brightness: Brightness.dark,
        background: _specs[this].colorBackgroundMain,
        error: _specs[this].colorAccentVariant,
        primary: _specs[this].colorPrimary,
        primaryVariant: _specs[this].colorPrimaryLight,
        secondary: _specs[this].colorSecondary,
        secondaryVariant: _specs[this].colorSecondaryVariant,
        surface: _specs[this].colorBackgroundMain);
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
        cardColor: _specs[this].colorBackgroundCard,
        backgroundColor: _specs[this].colorBackgroundMain,
        canvasColor: _specs[this].colorBackgroundMain,
        dialogBackgroundColor: _specs[this].colorBackgroundMain,
        scaffoldBackgroundColor: _specs[this].colorBackgroundMain,
        secondaryHeaderColor: _specs[this].colorPrimary050,
        dividerColor: _specs[this].colorPrimaryLight,
        splashColor: _specs[this].colorBackgroundMain,
        toggleableActiveColor: _specs[this].colorAccentVariant,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: _specs[this].colorBackgroundCard,
          iconTheme: IconThemeData(color: _specs[this].colorPrimary050),
        ),
        selectedRowColor: _specs[this].colorAccentVariant,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _specs[this].colorAccentVariant, width: 1.0))),
        accentIconTheme: IconThemeData(color: _specs[this].colorAccentVariant),
        primaryIconTheme: IconThemeData(color: _specs[this].colorAccentVariant),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: _specs[this].colorPrimaryDark,
            backgroundColor: _specs[this].colorAccentVariant));
  }
}
