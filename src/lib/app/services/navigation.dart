import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';

const String navigationRouteRoot = '/';
const String navigationRouteAbout = '/about';
const String navigationRouteAddPhraseGroup = '/add_group';
const String navigationRouteEditPhraseGroup = '/edit_group';
const String navigationRoutePhraseGroup = '/group';
const String navigationRouteAddPhrase = '/add_phrase';
const String navigationRouteEditPhrase = '/edit_phrase';
const String navigationRouteExercise = '/exercise';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == navigationRouteRoot) {
    return routePhraseGroupGridPage();
  }

  if (settings.name == navigationRouteAddPhraseGroup) {
    return routePhraseGroupEditorPage();
  }

  if (settings.name == navigationRouteEditPhraseGroup) {
    return routePhraseGroupEditorPage(initialGroupName: settings.arguments as String);
  }

  if (settings.name == navigationRoutePhraseGroup) {
    return routePhraseListPage(groupName: settings.arguments as String);
  }

  if (settings.name == navigationRouteAddPhrase) {
    return routePhraseEditorPage(settings.arguments as PhraseEditorPageArgument);
  }

  if (settings.name == navigationRouteEditPhrase) {
    return routePhraseEditorPage(settings.arguments as PhraseEditorPageArgument);
  }

  if (settings.name == navigationRouteExercise) {
    return routePhraseExercisePage(settings.arguments as PhraseExercisePageArgument);
  }

  if (settings.name == navigationRouteAbout) {
    return MaterialPageRoute<void>(builder: (context) => AboutPage());
  }

  assert(false);
  return routePhraseGroupGridPage();
}
