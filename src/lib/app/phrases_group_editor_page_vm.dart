import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/app/base/form_validation.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrases_group_editor_page_vm.navigation.dart';

class PhraseGroupEditorPageVM extends BaseViewModel<String> with FormValidation {
  String initialGroupName = '';
  String currentGroupName = '';

  bool get isNewGroup => initialGroupName.isEmpty;

  @override
  Future Function(String? argument) get initializer => (argument) async {
        initialGroupName = argument ?? '';
        currentGroupName = initialGroupName;
      };

  String? validatorForName(
      String? value, String messageWhenEmpty, String messageWhenAlreadyExists) {
    final empty =
        validationMessageWhenEmpty(value: value, messageWhenEmpty: () => messageWhenEmpty);

    if (empty != null) return empty;
    if (svc.repPhraseGroup.findSingle(value) != null) return messageWhenAlreadyExists;

    return null;
  }

  void updateName(String value) {
    currentGroupName = value;
    validateInlineIfNeeded();
  }

  void deleteAndClose() {
    if (isNewGroup) return;
    svc.repPhraseGroup.delete(initialGroupName);
    backWithResult(PhraseGroupEditorPageResult.deleted());
  }

  void tryApplyAndClose() {
    if (validate()) {
      final group = isNewGroup
          ? svc.repPhraseGroup.create(currentGroupName)
          : svc.repPhraseGroup.rename(initialGroupName, currentGroupName);

      backWithResult(PhraseGroupEditorPageResult.completed(group));
    }
  }
}
