import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseGroupGridModel {
  PhraseGroup? phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];

  bool get anySelected => phraseGroupSelected != null;
  bool get anySelectedAndNotEmpty =>
      phraseGroupSelected != null && phraseGroupSelected!.phraseCount > 0;
  bool get isNotEmpty => phraseGroups.isNotEmpty;

  bool isSelected(PhraseGroup item) => item.groupId == phraseGroupSelected?.groupId;

  PhraseGroupGridModel();
  PhraseGroupGridModel.from(
    PhraseGroupGridModel model, {
    PhraseGroup? phraseGroupSelected,
    List<PhraseGroup>? phraseGroups,
  }) {
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
  PhraseGroupGridViewModel() : super(PhraseGroupGridModel());

  void init() => _reset();

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

  void _reset() {
    emit(PhraseGroupGridModel.from(state, phraseGroups: svc.repPhraseGroup.findMany().toList()));
  }

  Future<void> switchLanguage() => svc.localization.switchLocale();
}
