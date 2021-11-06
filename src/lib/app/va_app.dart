import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/app/themes/va_theme_data.dart';
import 'package:vocabulary_advancer/app/va_app_vm.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class VAApp extends StatefulWidget {
  @override
  _VAAppState createState() => _VAAppState();
}

class _VAAppState extends State<VAApp> {
  @override
  Widget build(BuildContext context) => TranslationProvider(
        child: BlocProvider<VAAppViewModel>(
            create: (context) => VAAppViewModel(),
            child: BlocBuilder<VAAppViewModel, VAAppModel>(
              builder: (context, model) => VATheme(model.themeId,
                  child: MaterialApp.router(
                    routeInformationParser: svc.routeParser,
                    routerDelegate: svc.router,
                    debugShowCheckedModeBanner: false,
                    theme: getMaterialThemeData(model.themeId),
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate
                    ],
                    supportedLocales: LocaleSettings.supportedLocales,
                  )),
            )),
      );
}
