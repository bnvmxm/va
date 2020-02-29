import 'package:flutter/foundation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseListPageVM extends BaseViewModel<String> {
  String phraseGroupName;
  Phrase _phraseSelected;
  List<Phrase> phrases = [];

  bool get anySelected => isReady && _phraseSelected != null;
  bool get isNotEmpty => isReady && phrases.isNotEmpty;

  @override
  Future Function(String argument) get initializer => (argument) async {
        phraseGroupName = argument;
        phrases = svc.repPhrase.findMany(phraseGroupName).toList();
      };

  void select(Phrase item) {
    notify(() => _phraseSelected = item);
  }

  void unselect() {
    notify(() => _phraseSelected = null);
  }

  bool isSelected(Phrase item) => item == _phraseSelected;

  Future navigateToAddPhrase() => _navigateToEditor(isNew: true);
  Future navigateToEditPhrase() => _navigateToEditor(isNew: false);

  Future _navigateToEditor({@required bool isNew}) async {
    assert(isNew || anySelected);
  }
}
