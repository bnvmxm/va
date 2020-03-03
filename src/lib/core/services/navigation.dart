import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
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
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState
        .pushNamed<PhraseGroup>(def.routeEditPhraseGroup, arguments: groupName);
  }

  Future forwardToPhraseGroup(String groupName) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState
        .pushNamed(def.routePhraseGroup, arguments: groupName);
  }

  Future<Phrase> forwardToAddPhrase(String groupName) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed<Phrase>(def.routeAddPhrase,
        arguments: PhraseEditorPageArgument(groupName));
  }

  Future<Phrase> forwardToEditPhrase(PhraseEditorPageArgument arg) {
    assert(arg.phraseGroupName.isNotEmpty);
    assert(arg.id.isNotEmpty);
    return keys.navigation.currentState
        .pushNamed<Phrase>(def.routeEditPhrase, arguments: arg);
  }

  Future forwardToExercise(String groupName, {bool exampleFirst = true}) {
    assert(groupName.isNotEmpty);
    return keys.navigation.currentState.pushNamed(def.routeExercise,
        arguments: PhraseExercisePageArgument(groupName,
            isExerciseFirst: exampleFirst));
  }

  void back() {
    keys.navigation.currentState.pop();
  }

  void backWithResult<T>(T result) {
    keys.navigation.currentState.pop(result);
  }
}
