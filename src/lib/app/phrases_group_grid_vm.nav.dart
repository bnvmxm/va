part of 'phrases_group_grid_vm.dart';

Route routePhraseGroupGridPage() =>
    MaterialPageRoute<void>(builder: (context) => PhraseGroupGridPage());

extension on PhraseGroupGridViewModel {
  Future forwardToAbout() async =>
      navigationRoot.currentState?.pushNamed(navigationRouteAbout);

  Future<PhraseGroupEditorPageResult?> forwardToAddPhraseGroup() async =>
      navigationRoot.currentState?.pushNamed(navigationRouteAddPhraseGroup);

  Future<PhraseGroupEditorPageResult?> forwardToEditPhraseGroup(
      String groupName) async {
    assert(groupName.isNotEmpty);
    return navigationRoot.currentState?.pushNamed<PhraseGroupEditorPageResult>(
        navigationRouteEditPhraseGroup,
        arguments: groupName);
  }

  Future forwardToPhraseGroup(String groupName) async {
    assert(groupName.isNotEmpty);
    return navigationRoot.currentState
        ?.pushNamed(navigationRoutePhraseGroup, arguments: groupName);
  }

  Future forwardToExercise(String groupName, {bool exampleFirst = true}) async {
    assert(groupName.isNotEmpty);
    return navigationRoot.currentState?.pushNamed(navigationRouteExercise,
        arguments: PhraseExercisePageArgument(groupName,
            isExerciseFirst: exampleFirst));
  }
}
