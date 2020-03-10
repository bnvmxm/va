import 'package:flutter/material.dart';

part 'va_theme_spec_darkcold.dart';
part 'va_theme_spec_light.dart';

enum VAThemeId { darkCold, light }

//

class VATheme extends InheritedWidget {
  const VATheme(this.themeId, {Key key, @required Widget child}) : super(key: key, child: child);

  final VAThemeId themeId;

  static VAThemeSpecification of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<VATheme>();
    return theme.themeId == VAThemeId.darkCold
        ? VAColdDarkThemeSpecification()
        : VALightThemeSpecification();
  }

  @override
  bool updateShouldNotify(VATheme old) => old.themeId != themeId;
}

extension VAThemeIdExt on VAThemeId {
  ColorScheme asMaterialColorScheme() {
    final spec =
        this == VAThemeId.darkCold ? VAColdDarkThemeSpecification() : VALightThemeSpecification();

    return const ColorScheme.dark().copyWith(
        brightness: Brightness.dark,
        background: Color(spec.colorPrimary700),
        error: Color(spec.colorAccent),
        primary: Color(spec.colorPrimary500),
        primaryVariant: Color(spec.colorPrimary300),
        secondary: Color(spec.colorSecondary),
        secondaryVariant: Color(spec.colorSecondaryVariant),
        surface: Color(spec.colorPrimary700));
  }

  MaterialColor asMaterialColorSwatch() {
    final spec =
        this == VAThemeId.darkCold ? VAColdDarkThemeSpecification() : VALightThemeSpecification();

    return MaterialColor(spec.colorPrimary500, <int, Color>{
      50: Color(spec.colorPrimary050),
      100: Color(spec.colorPrimary100),
      200: Color(spec.colorPrimary200),
      300: Color(spec.colorPrimary300),
      400: Color(spec.colorPrimary400),
      500: Color(spec.colorPrimary500),
      600: Color(spec.colorPrimary600),
      700: Color(spec.colorPrimary700),
      800: Color(spec.colorPrimary800),
      900: Color(spec.colorPrimary900)
    });
  }

  ThemeData asMaterialThemeData() {
    final spec =
        this == VAThemeId.darkCold ? VAColdDarkThemeSpecification() : VALightThemeSpecification();
    final cs = asMaterialColorScheme();
    final swatch = asMaterialColorSwatch();

    return ThemeData(
        brightness: Brightness.dark,
        colorScheme: cs,
        accentColor: Color(spec.colorAccent),
        primaryColor: cs.primary,
        primaryColorLight: swatch[300],
        primaryColorDark: swatch[900],
        primarySwatch: swatch,
        cardColor: cs.primary,
        backgroundColor: cs.surface,
        canvasColor: cs.surface,
        dialogBackgroundColor: cs.surface,
        scaffoldBackgroundColor: cs.surface,
        secondaryHeaderColor: swatch[100],
        dividerColor: swatch[300],
        splashColor: swatch[300]);
  }
}
