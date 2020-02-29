import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/definitions.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class NavigationService {
  Future forwardToAbout() {
    return keys.navigation.currentState.pushNamed(def.routeAbout);
  }

  Future<PhraseGroup> forwardToAddPhraseGroup() {
    return keys.navigation.currentState.pushNamed(def.routeAddPhraseGroup);
  }

  Future<PhraseGroup> forwardToEditPhraseGroup(String groupName) {
    return keys.navigation.currentState
        .pushNamed<PhraseGroup>(def.routeEditPhraseGroup, arguments: groupName);
  }

  Future forwardToPhraseGroup(String groupName) {
    return keys.navigation.currentState.pushNamed(def.routePhraseGroup, arguments: groupName);
  }

  Future<Phrase> forwardToAddPhrase(String groupName) {}

  Future<Phrase> forwardToEditPhrase(String groupName, String phraseId) {}

  void back() {
    keys.navigation.currentState.pop();
  }

  void backWithResult<T>(T result) {
    keys.navigation.currentState.pop(result);
  }
}
