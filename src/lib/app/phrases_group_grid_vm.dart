import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/services/user_service.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseGroupGridModel {
  PhraseGroup? phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];
  VAAuth auth = VAAuth.unknown;

  bool get authenticated => auth == VAAuth.anonymous || auth == VAAuth.signedIn;
  bool get anySelected => phraseGroupSelected != null;
  bool get anySelectedAndNotEmpty =>
      phraseGroupSelected != null && phraseGroupSelected!.phraseCount > 0;
  bool get isNotEmpty => phraseGroups.isNotEmpty;

  bool isSelected(PhraseGroup item) => item.groupId == phraseGroupSelected?.groupId;

  PhraseGroupGridModel.init(this.auth);
  PhraseGroupGridModel.from(
    PhraseGroupGridModel model, {
    VAAuth? auth,
    PhraseGroup? phraseGroupSelected,
    List<PhraseGroup>? phraseGroups,
  }) {
    this.auth = auth ?? model.auth;
    this.phraseGroupSelected = phraseGroupSelected ?? model.phraseGroupSelected;
    this.phraseGroups = phraseGroups ?? model.phraseGroups;
  }

  void unselect() => phraseGroupSelected = null;
  void removeSelected() {
    if (anySelected) {
      phraseGroups.remove(phraseGroupSelected);
      phraseGroupSelected = null;
    }
  }

  void add(PhraseGroup? item) {
    if (item == null) return;
    phraseGroups.add(item);
  }

  void updateSelected(PhraseGroup? item) {
    if (item == null) return;
    for (var i = 0; i < phraseGroups.length; i++) {
      if (phraseGroups[i] == phraseGroupSelected) {
        phraseGroups[i] = item;
        break;
      }
    }
    phraseGroupSelected = item;
  }
}

class PhraseGroupGridViewModel extends Cubit<PhraseGroupGridModel> {
  late StreamSubscription<VAAuth> _authStateSubscription;

  PhraseGroupGridViewModel() : super(PhraseGroupGridModel.init(VAAuth.unknown));

  void init() {
    svc.userService.trackScreen(runtimeType.toString());
    _authStateSubscription = svc.userService.authState.listen((value) {
      if (state.auth != value) {
        if (value == VAAuth.anonymous || value == VAAuth.signedIn) {
          load(value);
        } else {
          emit(PhraseGroupGridModel.from(state, auth: value));
        }
      }
    });
  }

  void load(VAAuth auth) {
    svc.repPhraseGroup.findMany().then((items) {
      emit(PhraseGroupGridModel.from(state, auth: auth, phraseGroups: items.toList()));
    });
  }

  Future<void> signAnonymously() => svc.userService.signAnonymously();
  Future<void> signIn(String email, String passw) => svc.userService.signIn(email, passw);
  Future<void> signUn(String email, String passw) => svc.userService.signUp(email, passw);
  Future<void> signOut() => svc.userService.signOut();

  void select(PhraseGroup item) {
    emit(PhraseGroupGridModel.from(state, phraseGroupSelected: item));
  }

  void unselect() {
    emit(PhraseGroupGridModel.from(state..unselect()));
  }

  void navigateToEditor() => svc.route.pushForResult<PhraseGroupEditorPageResult>(
        state.phraseGroupSelected == null
            ? VARouteAddPhraseGroup()
            : VARouteEditPhraseGroup(state.phraseGroupSelected!.groupId),
        (result) {
          if (result.isDeleted) {
            emit(PhraseGroupGridModel.from(state..removeSelected()));
          } else if (result.isUpdated) {
            emit(PhraseGroupGridModel.from(state..updateSelected(result.group)));
          } else if (result.isAdded) {
            emit(PhraseGroupGridModel.from(state
              ..add(result.group)
              ..unselect()));
          }
        },
      );

  void navigateToGroup() {
    assert(state.phraseGroupSelected != null);
    svc.route.push(VARoutePhraseGroup(state.phraseGroupSelected!.groupId));
  }

  void navigateToExercise() {
    if (state.anySelectedAndNotEmpty) {
      svc.route.push(VARouteExercise(state.phraseGroupSelected!.groupId));
    }
  }

  void navigateToAbout() => svc.route.push(VARouteAbout());

  Future<void> switchLanguage() async {
    final loc = await svc.localization.switchLocale();
    svc.userService.trackEvent("locale", {"id": loc});
  }

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    await super.close();
  }
}
