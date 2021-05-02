import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/base/form_validation.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrases_group_editor_vm.nav.dart';

class PhraseGroupEditorModel {
  String initialGroupName = '';
  String currentGroupName = '';

  bool get isNewGroup => initialGroupName.isEmpty;

  PhraseGroupEditorModel(this.currentGroupName) {
    initialGroupName = currentGroupName;
  }

  PhraseGroupEditorModel.from(
    PhraseGroupEditorModel model, {
    String? initialGroupName,
    String? currentGroupName,
  }) {
    this.initialGroupName = initialGroupName ?? model.initialGroupName;
    this.currentGroupName = currentGroupName ?? model.currentGroupName;
  }
}

class PhraseGroupEditorViewModel extends Cubit<PhraseGroupEditorModel>
    with FormValidation {
  PhraseGroupEditorViewModel(String groupName)
      : super(PhraseGroupEditorModel(groupName));

  String? validatorForName(
      String? value, String messageWhenEmpty, String messageWhenAlreadyExists) {
    final empty = validationMessageWhenEmpty(
        value: value, messageWhenEmpty: () => messageWhenEmpty);

    if (empty != null) return empty;
    if (svc.repPhraseGroup.findSingle(value) != null) {
      return messageWhenAlreadyExists;
    }

    return null;
  }

  void updateName(String value) {
    state.currentGroupName = value;
    validateInlineIfNeeded();
  }

  void deleteAndClose() {
    if (state.isNewGroup) return;
    svc.repPhraseGroup.delete(state.initialGroupName);
    backWithResult(PhraseGroupEditorPageResult.deleted());
  }

  void tryApplyAndClose() {
    if (validate()) {
      final group = state.isNewGroup
          ? svc.repPhraseGroup.create(state.currentGroupName)
          : svc.repPhraseGroup
              .rename(state.initialGroupName, state.currentGroupName);

      backWithResult(PhraseGroupEditorPageResult.completed(group));
    }
  }
}
