part of 'phrase_list_page_vm.dart';

Route routePhraseListPage({required String groupName}) =>
    MaterialPageRoute<void>(builder: (context) => PhraseListPage(groupName: groupName));

extension on PhraseListPageVM {
  Future<PhraseEditorPageResult?> forwardToAddPhrase(String groupName) async {
    assert(groupName.isNotEmpty);
    return svc.keys.navigationRoot.currentState?.pushNamed<PhraseEditorPageResult?>(
        navigationRouteAddPhrase,
        arguments: PhraseEditorPageArgument(groupName));
  }

  Future<PhraseEditorPageResult?> forwardToEditPhrase(PhraseEditorPageArgument arg) async {
    assert(arg.phraseGroupName!.isNotEmpty);
    assert(arg.id!.isNotEmpty);
    return svc.keys.navigationRoot.currentState
        ?.pushNamed<PhraseEditorPageResult?>(navigationRouteEditPhrase, arguments: arg);
  }
}
