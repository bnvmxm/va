import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_parser.dart';
import 'package:vocabulary_advancer/app/navigation/va_router.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class VAApp extends StatefulWidget {
  @override
  _VAAppState createState() => _VAAppState();
}

class _VAAppState extends State<VAApp> {
  final VAThemeId _themeId = VAThemeId.darkCold;
  final VARouteParser _routeParser = VARouteParser();
  final VARouter _router = VARouter();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VATheme(
        _themeId,
        child: TranslationProvider(
          child: MaterialApp.router(
            routeInformationParser: _routeParser,
            routerDelegate: _router,
            debugShowCheckedModeBanner: false,
            theme: _themeId.getMaterialThemeData(),
            localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
            supportedLocales: LocaleSettings.supportedLocales,
          ),
        ),
      );
}
