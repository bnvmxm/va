import 'dart:collection';

import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseListPageVM extends BaseViewModel<String> {
  String phraseGroupName = '';
  int selectedIndex;
  List<Phrase> phrases = [];

  bool get isNotEmpty => isReady && phrases.isNotEmpty;
  bool get anySelected => selectedIndex != null;

  @override
  Future Function(String argument) get initializer => (argument) async {
        phraseGroupName = argument;
        phrases = svc.repPhrase.findMany(phraseGroupName).toList();
      };

  void select(int index) {
    notify(() => selectedIndex = index);
  }

  void unselect() {
    notify(() => selectedIndex = null);
  }

  bool isSelected(int index) => selectedIndex == index;

  Future navigateToAddPhrase() async {
    final result = await svc.nav.forwardToAddPhrase(phraseGroupName);

    if (result != null && result.groupName == phraseGroupName) {
      notify(() => phrases.add(result));
    }
  }

  Future navigateToEditPhrase() async {
    assert(selectedIndex != null);
    final selectedPhrase = phrases[selectedIndex];
    assert(selectedPhrase != null);

    final editedPhrase = await svc.nav.forwardToEditPhrase(PhraseEditorPageArgument(phraseGroupName,
        id: selectedPhrase.id,
        phrase: selectedPhrase.phrase,
        pronunciation: selectedPhrase.pronunciation,
        definition: selectedPhrase.definition,
        examples: UnmodifiableListView(selectedPhrase.examples)));

    if (editedPhrase == null) return;

    if (editedPhrase.groupName == phraseGroupName) {
      notify(() => phrases[selectedIndex] = editedPhrase);
    } else {
      // moved to another group
      notify(() {
        phrases.removeAt(selectedIndex);
        selectedIndex = null;
      });
    }
  }
}
