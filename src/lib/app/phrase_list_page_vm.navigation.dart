part of 'phrase_list_page_vm.dart';

Route routePhraseListPage({String groupName}) =>
    MaterialPageRoute(builder: (context) => PhraseListPage(groupName: groupName));

extension on PhraseListPageVM {
  Future<PhraseEditorPageResult> forwardToAddPhrase(String groupName) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed<PhraseEditorPageResult>(navigationRouteAddPhrase,
        arguments: PhraseEditorPageArgument(groupName));
  }

  Future<PhraseEditorPageResult> forwardToEditPhrase(PhraseEditorPageArgument arg) {
    assert(arg.phraseGroupName.isNotEmpty);
    assert(arg.id.isNotEmpty);
    return keys.navigation.currentState
        .pushNamed<PhraseEditorPageResult>(navigationRouteEditPhrase, arguments: arg);
  }
}
