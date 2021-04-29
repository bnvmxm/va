import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page.dart';
import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrases_group_grid_page_vm.navigation.dart';

class PhraseGroupGridPageVM extends BaseViewModel<void> {
  PhraseGroup? _phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];

  bool get anySelected => isReady && _phraseGroupSelected != null;
  bool get anySelectedAndNotEmpty =>
      isReady && _phraseGroupSelected != null && _phraseGroupSelected!.phraseCount > 0;
  bool get isNotEmpty => isReady && phraseGroups.isNotEmpty;

  @override
  Future Function(void) get initializer => (_) async => _reset();

  Future _reset() async {
    phraseGroups = svc.repPhraseGroup.findMany().toList();
  }

  void select(PhraseGroup item) {
    notify(() => _phraseGroupSelected = item);
  }

  void unselect() {
    notify(() => _phraseGroupSelected = null);
  }

  bool isSelected(PhraseGroup item) => item == _phraseGroupSelected;

  Future navigateToAddGroup() => _navigateToEditor(isNew: true);
  Future navigateToEditGroup() => _navigateToEditor(isNew: false);
  Future _navigateToEditor({required bool isNew}) async {
    assert(isNew || anySelected);
    final result = isNew
        ? await forwardToAddPhraseGroup()
        : await forwardToEditPhraseGroup(_phraseGroupSelected!.name);

    if (result?.group == null) return;

    notify(() {
      if (isNew) {
        phraseGroups.add(result!.group!);
      } else if (result!.isDeleted) {
        phraseGroups.remove(_phraseGroupSelected);
        _phraseGroupSelected = null;
      } else {
        for (var i = 0; i < phraseGroups.length; i++) {
          if (phraseGroups[i] == _phraseGroupSelected) {
            phraseGroups[i] = result.group!;
          }
        }
        _phraseGroupSelected = result.group;
      }
    });
  }

  Future navigateToGroup() async {
    assert(_phraseGroupSelected != null);
    await forwardToPhraseGroup(_phraseGroupSelected!.name);
    _phraseGroupSelected = null;
    notify(() async => _reset(), asBusy: true);
  }

  Future navigateToAbout() async => forwardToAbout();

  Future navigateToExercise() async {
    assert(_phraseGroupSelected != null);
    if (_phraseGroupSelected!.phraseCount > 0) {
      await forwardToExercise(_phraseGroupSelected!.name);
      _phraseGroupSelected = null;
      notify(() async => _reset(), asBusy: true);
    }
  }

  Future<void> nextLanguage() => svc.localizationService.switchLocale();
}
