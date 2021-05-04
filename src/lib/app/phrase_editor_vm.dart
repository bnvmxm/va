// ignore_for_file: use_setters_to_change_properties

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/base/form_validation.dart';
import 'package:vocabulary_advancer/app/base/va_app.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_editor_vm.nav.dart';

class PhraseEditorModel {
  bool isLoading = false;

  PhraseEditorPageArgument? initialValues;
  String phraseGroupName = '';
  String id = '';
  String phrase = '';
  String definition = '';
  String pronunciation = '';
  List<String> examples = [];
  List<String> phraseGroupsKnown = [];

  PhraseEditorModel.fromArgument(PhraseEditorPageArgument? arg) {
    initialValues = arg;
    phraseGroupName = arg?.phraseGroupName ?? '';
    id = arg?.id ?? '';
    phrase = arg?.phrase ?? '';
    pronunciation = arg?.pronunciation ?? '';
    definition = arg?.definition ?? '';
    examples = List.from(arg?.examples ?? <String>[]);

    phraseGroupsKnown = svc.repPhraseGroup.findKnownNames().toList();
  }

  PhraseEditorModel.from(
    PhraseEditorModel model, {
    bool? isLoading,
    String? phraseGroupName,
    String? id,
    String? phrase,
    String? definition,
    String? pronunciation,
    List<String>? examples,
    List<String>? phraseGroupsKnown,
  }) {
    this.isLoading = isLoading ?? model.isLoading;
    this.phraseGroupName = phraseGroupName ?? model.phraseGroupName;
    this.id = id ?? model.id;
    this.phrase = phrase ?? model.phrase;
    this.definition = definition ?? model.definition;
    this.pronunciation = pronunciation ?? model.pronunciation;
    this.examples = examples ?? model.examples;
    this.phraseGroupsKnown = phraseGroupsKnown ?? model.phraseGroupsKnown;
  }

  List<String> get phraseGroupsKnownExceptSelected =>
      phraseGroupsKnown.where((x) => x != phraseGroupName).toList();

  bool get isNewPhrase => id.isEmpty;
}

class PhraseEditorViewModel extends Cubit<PhraseEditorModel>
    with FormValidation {
  PhraseEditorViewModel(PhraseEditorPageArgument? arg)
      : super(PhraseEditorModel.fromArgument(arg));

  void updateGroupName(String value) {
    emit(PhraseEditorModel.from(state, phraseGroupName: value));
  }

  void updatePhrase(String value) {
    state.phrase = value;
    validateInlineIfNeeded();
  }

  void updateDefinition(String value) {
    state.definition = value;
    validateInlineIfNeeded();
  }

  void updatePronunciation(String value) {
    state.pronunciation = value;
  }

  void addExample(String? value) {
    if (value?.isNotEmpty ?? false) {
      emit(
          PhraseEditorModel.from(state, examples: state.examples..add(value!)));
      validateInlineIfNeeded();
    }
  }

  void removeExample(int index) {
    state.examples.removeAt(index);
    emit(PhraseEditorModel.from(state,
        examples: state.examples..removeAt(index)));
  }

  String? validatorForPhrase(String? value, String validationMessage) =>
      validationMessageWhenEmpty(
          value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForDefinition(String? value, String validationMessage) =>
      validationMessageWhenEmpty(
          value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForExamples(String validationMessage) =>
      state.examples.isEmpty ? validationMessage : null;

  void deletePhraseAndClose() {
    if (!state.isNewPhrase) {
      svc.repPhrase.delete(state.phraseGroupName, state.id);
    }

    backWithResult(PhraseEditorPageResult.deleted());
  }

  void tryApplyAndClose() {
    if (validate()) {
      assert(state.phraseGroupName.isNotEmpty);

      final result = state.isNewPhrase
          ? svc.repPhrase.create(
              state.phraseGroupName,
              state.phrase,
              state.pronunciation,
              state.definition,
              state.examples,
            )
          : svc.repPhrase.update(
              state.initialValues?.phraseGroupName,
              state.phraseGroupName,
              state.id,
              state.phrase,
              state.pronunciation,
              state.definition,
              state.examples,
            );

      backWithResult(PhraseEditorPageResult.completed(result));
    }
  }
}
