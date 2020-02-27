import 'package:vocabulary_advancer/shared/definitions.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class NavigationService {
  Future forwardToAbout() {
    return keys.navigation.currentState.pushNamed(def.routeAbout);
  }

  Future forwardToAddGroup() {
    return keys.navigation.currentState.pushNamed(def.routeAddPhraseGroup);
  }

  Future forwardToEditGroup(String groupName) {
    return keys.navigation.currentState.pushNamed(def.routeEditPhraseGroup, arguments: groupName);
  }

  void back() {
    keys.navigation.currentState.pop();
  }

  void backWithResult<T>(T result) {
    keys.navigation.currentState.pop(result);
  }
}
