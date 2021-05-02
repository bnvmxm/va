part of 'phrases_group_editor_vm.dart';

Route<PhraseGroupEditorPageResult> routePhraseGroupEditorPage(
        {String initialGroupName = ''}) =>
    MaterialPageRoute<PhraseGroupEditorPageResult>(
        builder: (context) =>
            PhraseGroupEditorPage(initialGroupName: initialGroupName),
        fullscreenDialog: true);

class PhraseGroupEditorPageResult {
  PhraseGroupEditorPageResult.deleted()
      : isDeleted = true,
        group = null;
  PhraseGroupEditorPageResult.completed(this.group) : isDeleted = false;

  final bool isDeleted;
  final PhraseGroup? group;
}

extension on PhraseGroupEditorViewModel {
  void backWithResult(PhraseGroupEditorPageResult? result) {
    svc.keys.navigationRoot.currentState?.pop(result);
  }
}
