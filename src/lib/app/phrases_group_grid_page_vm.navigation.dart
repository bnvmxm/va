part of 'phrases_group_grid_page_vm.dart';

Route routePhraseGroupGridPage() =>
    MaterialPageRoute<void>(builder: (context) => PhraseGroupGridPage());

extension on PhraseGroupGridPageVM {
  Future forwardToAbout() async =>
      svc.keys.navigationRoot.currentState?.pushNamed(navigationRouteAbout);

  Future<PhraseGroupEditorPageResult?> forwardToAddPhraseGroup() async =>
      svc.keys.navigationRoot.currentState?.pushNamed(navigationRouteAddPhraseGroup);

  Future<PhraseGroupEditorPageResult?> forwardToEditPhraseGroup(String groupName) async {
    assert(groupName.isNotEmpty);
    return svc.keys.navigationRoot.currentState?.pushNamed<PhraseGroupEditorPageResult>(
        navigationRouteEditPhraseGroup,
        arguments: groupName);
  }

  Future forwardToPhraseGroup(String groupName) async {
    assert(groupName.isNotEmpty);
    return svc.keys.navigationRoot.currentState
        ?.pushNamed(navigationRoutePhraseGroup, arguments: groupName);
  }

  Future forwardToExercise(String groupName, {bool exampleFirst = true}) async {
    assert(groupName.isNotEmpty);
    return svc.keys.navigationRoot.currentState?.pushNamed(navigationRouteExercise,
        arguments: PhraseExercisePageArgument(groupName, isExerciseFirst: exampleFirst));
  }
}
