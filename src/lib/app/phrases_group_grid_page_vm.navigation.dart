part of 'phrases_group_grid_page_vm.dart';

Route routePhraseGroupGridPage() => MaterialPageRoute(builder: (context) => PhraseGroupGridPage());

extension on PhraseGroupGridPageVM {
  Future forwardToAbout() {
    return keys.navigation.currentState.pushNamed(navigationRouteAbout);
  }

  Future<PhraseGroupEditorPageResult> forwardToAddPhraseGroup() {
    return keys.navigation.currentState.pushNamed(navigationRouteAddPhraseGroup);
  }

  Future<PhraseGroupEditorPageResult> forwardToEditPhraseGroup(String groupName) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed<PhraseGroupEditorPageResult>(
        navigationRouteEditPhraseGroup,
        arguments: groupName);
  }

  Future forwardToPhraseGroup(String groupName) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed(navigationRoutePhraseGroup, arguments: groupName);
  }

  Future forwardToExercise(String groupName, {bool exampleFirst = true}) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed(navigationRouteExercise,
        arguments: PhraseExercisePageArgument(groupName, isExerciseFirst: exampleFirst));
  }
}
