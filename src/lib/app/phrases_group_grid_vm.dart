import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page.dart';
import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrases_group_grid_vm.nav.dart';

class PhraseGroupGridModel {
  PhraseGroup? phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];

  bool get anySelected => phraseGroupSelected != null;
  bool get anySelectedAndNotEmpty =>
      phraseGroupSelected != null && phraseGroupSelected!.phraseCount > 0;
  bool get isNotEmpty => phraseGroups.isNotEmpty;

  bool isSelected(PhraseGroup item) => item.name == phraseGroupSelected?.name;

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

  void updateSelected(PhraseGroup item) {
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

  Future navigateToAddGroup() => _navigateToEditor(isNew: true);
  Future navigateToEditGroup() => _navigateToEditor(isNew: false);

  Future _navigateToEditor({required bool isNew}) async {
    assert(isNew || state.anySelected);
    final result = isNew
        ? await forwardToAddPhraseGroup()
        : await forwardToEditPhraseGroup(state.phraseGroupSelected!.name);

    if (result?.isDeleted ?? false) {
      state.removeSelected();
    } else if (isNew && result?.group != null) {
      state.phraseGroups.add(result!.group!);
    } else if (result?.group != null) {
      state.updateSelected(result!.group!);
    }

    emit(PhraseGroupGridModel.from(state));
  }

  Future navigateToGroup() async {
    assert(state.phraseGroupSelected != null);
    await forwardToPhraseGroup(state.phraseGroupSelected!.name);
    state.unselect();
    await _reset();
  }

  Future navigateToExercise() async {
    if (state.anySelectedAndNotEmpty) {
      await forwardToExercise(state.phraseGroupSelected!.name);
      state.unselect();
      await _reset();
    }
  }

  Future navigateToAbout() async => forwardToAbout();

  Future _reset() async {
    emit(PhraseGroupGridModel.from(state,
        phraseGroups: svc.repPhraseGroup.findMany().toList()));
  }

  Future<void> nextLanguage() => svc.localizationService.switchLocale();
}
