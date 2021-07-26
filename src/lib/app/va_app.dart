import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/app/va_app_vm.dart';

final GlobalKey<NavigatorState> navigationRoot = GlobalKey<NavigatorState>();

class VAApp extends StatefulWidget {
  @override
  _VAAppState createState() => _VAAppState();
}

class _VAAppState extends State<VAApp> {
  final _themes = <VAThemeId, VAThemeSpecification>{
    VAThemeId.darkCold: VAColdDarkThemeSpecification(),
    VAThemeId.light: VALightThemeSpecification()
  };

  @override
  Widget build(BuildContext context) => TranslationProvider(
        child: BlocProvider<VAAppViewModel>(
            create: (context) => VAAppViewModel(),
            child: BlocBuilder<VAAppViewModel, VAAppModel>(
              builder: (context, model) => VATheme(model.themeId,
                  child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: _getMaterialThemeData(model.themeId),
                      localizationsDelegates: const [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: LocaleSettings.supportedLocales,
                      navigatorKey: navigationRoot,
                      onGenerateRoute: generateRoute)),
            )),
      );

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

  ThemeData _getMaterialThemeData(VAThemeId themeId) {
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
        accentColor: th.colorTextAccent,
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
          brightness: cs.brightness,
          backgroundColor: th.colorBackgroundCard,
          textTheme: texts,
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
        accentIconTheme: IconThemeData(color: th.colorBackgroundIconSelected),
        primaryIconTheme: IconThemeData(color: th.colorBackgroundIconUnselected),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: th.colorForegroundIconSelected,
            backgroundColor: th.colorBackgroundIconSelected),
        textTheme: texts);
  }
}
