// ignore_for_file: use_setters_to_change_properties

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/app/base/form_validation.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

part 'phrase_editor_page_vm.navigation.dart';

class PhraseEditorPageVM extends BaseViewModel<PhraseEditorPageArgument> with FormValidation {
  PhraseEditorPageArgument initialValues;

  String phraseGroupName = '';
  String id = '';
  String phrase = '';
  String definition = '';
  String pronunciation = '';
  List<String> examples = [];

  List<String> phraseGroupsKnown = [];
  List<String> get phraseGroupsKnownExceptSelected =>
      phraseGroupsKnown.where((x) => x != phraseGroupName).toList();

  bool get isNewPhrase => id.isEmpty;

  @override
  Future Function(PhraseEditorPageArgument argument) get initializer => (argument) async {
        initialValues = argument;
        phraseGroupName = initialValues.phraseGroupName ?? '';
        id = initialValues.id ?? '';
        phrase = initialValues.phrase ?? '';
        pronunciation = initialValues.pronunciation ?? '';
        definition = initialValues.definition ?? '';
        if (initialValues.examples?.isNotEmpty ?? false) {
          examples = List.from(initialValues.examples);
        }

        phraseGroupsKnown = svc.repPhraseGroup.findKnownNames().toList();
      };

  void updateGroupName(String value) {
    notify(() => phraseGroupName = value);
  }

  String validatorForPhrase(String value, String validationMessage) {
    return validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);
  }

  void updatePhrase(String value) {
    phrase = value;
    validateInlineIfNeeded();
  }

  void updatePronunciation(String value) {
    pronunciation = value;
  }

  String validatorForDefinition(String value, String validationMessage) {
    return validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);
  }

  void updateDefinition(String value) {
    definition = value;
    validateInlineIfNeeded();
  }

  String validatorForExamples(String validationMessage) =>
      examples.isEmpty ? validationMessage : null;

  void addExample(String value) {
    if (value?.isNotEmpty ?? false) {
      notify(() => examples.add(value));
      validateInlineIfNeeded();
    }
  }

  void removeExample(int index) {
    notify(() => examples.removeAt(index));
  }

  void deletePhraseAndClose() {
    if (!isNewPhrase) {
      svc.repPhrase.delete(phraseGroupName, id);
    }

    backWithResult(PhraseEditorPageResult.deleted());
  }

  void tryApplyAndClose() {
    if (validate()) {
      assert(phraseGroupName.isNotEmpty);

      final result = isNewPhrase
          ? svc.repPhrase.create(phraseGroupName, phrase, pronunciation, definition, examples)
          : svc.repPhrase.update(initialValues.phraseGroupName, phraseGroupName, id, phrase,
              pronunciation, definition, examples);

      backWithResult(PhraseEditorPageResult.completed(result));
    }
  }
}
