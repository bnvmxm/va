// ignore_for_file: use_setters_to_change_properties

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/form_validation.dart';
import 'package:vocabulary_advancer/app/navigation/va_router.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseEditorModel {
  bool isLoading = true;
  Phrase? initial;

  int phraseGroupId = 0;
  String? phraseUid;
  String phrase = '';
  String definition = '';
  String pronunciation = '';
  List<String> examples = [];
  Map<int, String> phraseGroupsKnown = {};

  PhraseEditorModel(this.phraseGroupId, this.phraseUid);

  PhraseEditorModel.from(
    PhraseEditorModel model, {
    bool? isLoading,
    Phrase? initial,
    int? phraseGroupId,
    String? phraseUid,
    String? phrase,
    String? definition,
    String? pronunciation,
    List<String>? examples,
    Map<int, String>? phraseGroupsKnown,
  }) {
    this.isLoading = isLoading ?? model.isLoading;
    this.initial = initial ?? model.initial;
    this.phraseGroupId = phraseGroupId ?? model.phraseGroupId;
    this.phraseUid = phraseUid ?? model.phraseUid;
    this.phrase = phrase ?? model.phrase;
    this.definition = definition ?? model.definition;
    this.pronunciation = pronunciation ?? model.pronunciation;
    this.examples = examples ?? model.examples;
    this.phraseGroupsKnown = phraseGroupsKnown ?? model.phraseGroupsKnown;
  }

  String get phraseGroupName => phraseGroupsKnown[phraseGroupId] ?? '';

  List<int> get phraseGroupsExceptSelected =>
      phraseGroupsKnown.keys.where((groupId) => groupId != phraseGroupId).toList();

  bool get isNewPhrase => phraseUid == null;
}

class PhraseEditorPageResult {
  PhraseEditorPageResult.deleted()
      : isDeleted = true,
        phrase = null;
  PhraseEditorPageResult.completed(this.phrase) : isDeleted = false;

  final bool isDeleted;
  final Phrase? phrase;
}

class PhraseEditorViewModel extends Cubit<PhraseEditorModel> with FormValidation {
  PhraseEditorViewModel(int groupId, [String? phraseUid])
      : super(PhraseEditorModel(groupId, phraseUid));

  void init() {
    final groups = svc.repPhraseGroup.findKnownNames();
    final initial = svc.repPhrase.find(state.phraseGroupId, state.phraseUid!);

    if (initial != null) {
      emit(PhraseEditorModel.from(
        state,
        isLoading: false,
        initial: initial,
        phraseGroupsKnown: groups,
        phrase: initial.phrase,
        definition: initial.definition,
        examples: initial.examples,
        pronunciation: initial.pronunciation,
      ));
    } else {
      emit(PhraseEditorModel.from(
        state,
        isLoading: false,
        phraseGroupsKnown: groups,
      ));
    }
  }

  void updateGroup(String value) {
    final groupId = state.phraseGroupsKnown.entries.singleWhere((x) => x.value == value).key;
    emit(PhraseEditorModel.from(state, phraseGroupId: groupId));
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
      emit(PhraseEditorModel.from(state, examples: state.examples..add(value!)));
      validateInlineIfNeeded();
    }
  }

  void removeExample(int index) {
    state.examples.removeAt(index);
    emit(PhraseEditorModel.from(state, examples: state.examples..removeAt(index)));
  }

  String? validatorForPhrase(String? value, String validationMessage) =>
      validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForDefinition(String? value, String validationMessage) =>
      validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForExamples(String validationMessage) =>
      state.examples.isEmpty ? validationMessage : null;

  void deletePhraseAndClose() {
    if (!state.isNewPhrase) {
      svc.repPhrase.delete(state.phraseGroupId, state.phraseUid!);
    }

    VARoute.i.popWithResult(PhraseEditorPageResult.deleted());
  }

  void tryApplyAndClose() {
    if (validate()) {
      final result = state.isNewPhrase
          ? svc.repPhrase.create(
              state.phraseGroupId,
              state.phrase,
              state.pronunciation,
              state.definition,
              state.examples,
            )
          : svc.repPhrase.update(
              state.initial?.groupId,
              state.phraseGroupId,
              state.phraseUid!,
              state.phrase,
              state.pronunciation,
              state.definition,
              state.examples,
            );

      VARoute.i.popWithResult(PhraseEditorPageResult.completed(result));
    }
  }
}
