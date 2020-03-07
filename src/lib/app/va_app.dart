import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class VAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const i18n = I18n.delegate;
    setI18n(I18n.of(context));
    return MaterialApp(
        title: svc.i18n.titlesAppName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          i18n,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: i18n.supportedLocales,
        navigatorKey: keys.navigation,
        initialRoute: def.routeRoot,
        onGenerateRoute: _generateRoute);
  }
}

Route<dynamic> _generateRoute(RouteSettings settings) {
  if (settings?.name == def.routeRoot) {
    return MaterialPageRoute(builder: (context) => PhraseGroupGridPage());
  }
  if (settings?.name == def.routeAbout) {
    return MaterialPageRoute(builder: (context) => AboutPage());
  }
  if (settings?.name == def.routeAddPhraseGroup) {
    return MaterialPageRoute<PhraseGroup>(
        builder: (context) => PhraseGroupEditorPage(), fullscreenDialog: true);
  }
  if (settings?.name == def.routeEditPhraseGroup) {
    return MaterialPageRoute<PhraseGroup>(
        builder: (context) => PhraseGroupEditorPage(
            initialGroupName: settings.arguments as String),
        fullscreenDialog: true);
  }
  if (settings?.name == def.routePhraseGroup) {
    return MaterialPageRoute(
        builder: (context) =>
            PhraseListPage(groupName: settings.arguments as String));
  }
  if (settings?.name == def.routeAddPhrase) {
    return MaterialPageRoute<Phrase>(
        builder: (context) =>
            PhraseEditorPage(settings.arguments as PhraseEditorPageArgument),
        fullscreenDialog: true);
  }
  if (settings?.name == def.routeEditPhrase) {
    return MaterialPageRoute<Phrase>(
        builder: (context) =>
            PhraseEditorPage(settings.arguments as PhraseEditorPageArgument),
        fullscreenDialog: true);
  }
  if (settings?.name == def.routeExercise) {
    return MaterialPageRoute(
        builder: (context) => PhraseExercisePage(
            settings.arguments as PhraseExercisePageArgument));
  }
  assert(false);
  return MaterialPageRoute(builder: (context) => AboutPage());
}
