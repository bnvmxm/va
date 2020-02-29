import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/phrase_group_editor_page.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class VAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vocabulary Advancer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
        builder: (context) => PhraseGroupEditorPage(initialGroupName: settings.arguments as String),
        fullscreenDialog: true);
  }
  if (settings?.name == def.routePhraseGroup) {
    return MaterialPageRoute(
        builder: (context) => PhraseListPage(groupName: settings.arguments as String));
  }
  assert(false);
  return MaterialPageRoute(builder: (context) => AboutPage());
}
