part of 'phrase_list_vm.dart';

Route routePhraseListPage({required String groupName}) =>
    MaterialPageRoute<void>(
        builder: (context) => PhraseListPage(groupName: groupName));

extension on PhraseListViewModel {
  Future<PhraseEditorPageResult?> forwardToAddPhrase(String groupName) async {
    assert(groupName.isNotEmpty);
    return navigationRoot.currentState?.pushNamed<PhraseEditorPageResult?>(
        navigationRouteAddPhrase,
        arguments: PhraseEditorPageArgument(groupName));
  }

  Future<PhraseEditorPageResult?> forwardToEditPhrase(
      PhraseEditorPageArgument arg) async {
    assert(arg.phraseGroupName!.isNotEmpty);
    assert(arg.id!.isNotEmpty);
    return navigationRoot.currentState?.pushNamed<PhraseEditorPageResult?>(
        navigationRouteEditPhrase,
        arguments: arg);
  }
}
