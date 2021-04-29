part of 'phrase_editor_page_vm.dart';

Route<PhraseEditorPageResult> routePhraseEditorPage(PhraseEditorPageArgument argument) =>
    MaterialPageRoute<PhraseEditorPageResult>(
        builder: (context) => PhraseEditorPage(argument), fullscreenDialog: true);

class PhraseEditorPageArgument {
  PhraseEditorPageArgument(this.phraseGroupName,
      {this.id, this.phrase, this.definition, this.pronunciation, this.examples});
  final String? phraseGroupName;
  final String? id;
  final String? phrase;
  final String? definition;
  final String? pronunciation;
  final UnmodifiableListView<String>? examples;
}

class PhraseEditorPageResult {
  PhraseEditorPageResult.deleted()
      : isDeleted = true,
        phrase = null;
  PhraseEditorPageResult.completed(this.phrase) : isDeleted = false;

  final bool isDeleted;
  final Phrase? phrase;
}

extension on PhraseEditorPageVM {
  void backWithResult(PhraseEditorPageResult result) {
    svc.keys.navigationRoot.currentState?.pop(result);
  }
}
