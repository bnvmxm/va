import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/phrase_group_editor_page.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page.dart';

const String routeNameRoot = '/';
const String routeNameAbout = '/about';
const String routeNameAddPhraseGroup = '/add_group';
const String routeNameEditPhraseGroup = '/edit_group';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings?.name) {
    case routeNameRoot:
      return MaterialPageRoute(builder: (context) => PhraseGroupGridPage());
    case routeNameAbout:
      return MaterialPageRoute(builder: (context) => AboutPage());
    case routeNameAddPhraseGroup:
      return MaterialPageRoute(
          builder: (context) => PhraseGroupEditorPage(), fullscreenDialog: true);
    case routeNameEditPhraseGroup:
      return MaterialPageRoute(
          builder: (context) =>
              PhraseGroupEditorPage(currentGroupName: settings.arguments as String),
          fullscreenDialog: true);
    default:
      assert(false);
      return MaterialPageRoute(builder: (context) => AboutPage());
  }
}

extension PhraseGroupGridPageNavigation on PhraseGroupGridPage {
  Future pushToAbout(BuildContext context) {
    return Navigator.pushNamed(context, routeNameAbout);
  }

  Future pushToAddGroup(BuildContext context) {
    return Navigator.pushNamed(context, routeNameAddPhraseGroup);
  }

  Future pushToEditGroup(BuildContext context, String groupName) {
    return Navigator.pushNamed(context, routeNameEditPhraseGroup, arguments: groupName);
  }
}

extension PhraseGroupEditorPageNavigation on PhraseGroupEditorPage {
  void back(BuildContext context) {
    Navigator.pop(context);
  }
}
