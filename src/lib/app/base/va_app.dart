import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class VAApp extends StatefulWidget {
  @override
  _VAAppState createState() => _VAAppState();
}

class _VAAppState extends State<VAApp> {
  VAThemeId _themeId;

  @override
  void initState() {
    super.initState();
    _themeId = VAThemeId.darkCold;
    I18n.onLocaleChanged = _onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    const i18n = I18n.delegate;
    return VATheme(
      _themeId,
      child: MaterialApp(
          theme: _themeId.getMaterialThemeData(),
          localizationsDelegates: const [
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: i18n.supportedLocales,
          localeResolutionCallback: i18n.resolution(fallback: const Locale("en", "US")),
          navigatorKey: keys.navigation,
          initialRoute: navigationRouteRoot,
          onGenerateRoute: (settings) => generateRoute(settings)),
    );
  }

  void _onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }
}
