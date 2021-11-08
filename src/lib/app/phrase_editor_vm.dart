// ignore_for_file: use_setters_to_change_properties

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/form_validation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseEditorModel {
  bool isLoading = true;
  Phrase? initial;

  String? phraseGroupId;
  String? phraseId;
  String phrase = '';
  String definition = '';
  String pronunciation = '';
  List<String> examples = [];
  Map<String, String> phraseGroupsKnown = {};

  PhraseEditorModel(this.phraseGroupId, this.phraseId);

  PhraseEditorModel.from(
    PhraseEditorModel model, {
    bool isLoading = false,
    Phrase? initial,
    String? phraseGroupId,
    String? phraseId,
    String? phrase,
    String? definition,
    String? pronunciation,
    List<String>? examples,
    Map<String, String>? phraseGroupsKnown,
  }) {
    this.isLoading = isLoading;
    this.initial = initial ?? model.initial;
    this.phraseGroupId = phraseGroupId ?? model.phraseGroupId;
    this.phraseId = phraseId ?? model.phraseId;
    this.phrase = phrase ?? model.phrase;
    this.definition = definition ?? model.definition;
    this.pronunciation = pronunciation ?? model.pronunciation;
    this.examples = examples ?? model.examples;
    this.phraseGroupsKnown = phraseGroupsKnown ?? model.phraseGroupsKnown;
  }

  String get phraseGroupName => phraseGroupsKnown[phraseGroupId] ?? '';

  List<String> get phraseGroupsExceptSelected =>
      phraseGroupsKnown.keys.where((groupId) => groupId != phraseGroupId).toList();

  bool get isNewPhrase => phraseId == null;
}

class PhraseEditorPageResult {
  PhraseEditorPageResult.deleted(this.phrase)
      : isDeleted = true,
        isAdded = false,
        isUpdated = false;
  PhraseEditorPageResult.added(this.phrase)
      : isDeleted = false,
        isAdded = true,
        isUpdated = false;
  PhraseEditorPageResult.updated(this.phrase)
      : isDeleted = false,
        isAdded = false,
        isUpdated = true;

  final bool isDeleted;
  final bool isAdded;
  final bool isUpdated;
  final Phrase? phrase;
}

class PhraseEditorViewModel extends Cubit<PhraseEditorModel> with FormValidation {
  PhraseEditorViewModel(String groupId, [String? phraseId])
      : super(PhraseEditorModel(groupId, phraseId));

  void init() {
    svc.repPhraseGroup.findKnownNames().then((groupNames) {
      _findInitialPhrase(state.phraseGroupId, state.phraseId).then((initial) {
        if (initial != null) {
          emit(PhraseEditorModel.from(
            state,
            initial: initial,
            phraseGroupsKnown: groupNames,
            phrase: initial.phrase,
            definition: initial.definition,
            examples: initial.examples,
            pronunciation: initial.pronunciation,
          ));
        } else {
          emit(PhraseEditorModel.from(
            state,
            phraseGroupsKnown: groupNames,
          ));
        }
      });
    });
  }

  Future<Phrase?> _findInitialPhrase(String? groupId, String? phraseId) async =>
      state.phraseGroupId == null || state.phraseId == null
          ? null
          : await svc.repPhrase.find(state.phraseGroupId!, state.phraseId!);

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
    emit(PhraseEditorModel.from(state, examples: state.examples..removeAt(index)));
  }

  String? validatorForPhrase(String? value, String validationMessage) =>
      validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForDefinition(String? value, String validationMessage) =>
      validationMessageWhenEmpty(value: value, messageWhenEmpty: () => validationMessage);

  String? validatorForExamples(String validationMessage) =>
      state.examples.isEmpty ? validationMessage : null;

  Future<void> deletePhraseAndClose() async {
    if (state.isNewPhrase) return;

    final phrase = await svc.repPhrase.delete(state.phraseGroupId!, state.phraseId!);
    svc.route.popWithResult(PhraseEditorPageResult.deleted(phrase));
  }

  Future<void> tryApplyAndClose() async {
    const defaultRate = 11;
    const defaultCooldown = Duration(minutes: 2);

    if (validate()) {
      if (state.isNewPhrase) {
        final result = await svc.repPhrase.create(
            state.phraseGroupId!,
            state.phrase,
            state.pronunciation,
            state.definition,
            state.examples,
            defaultRate,
            <int>[],
            DateTime.now().toUtc().add(defaultCooldown));
        if (result != null) {
          svc.route.popWithResult(PhraseEditorPageResult.added(result));
        }
      } else {
        final result = await svc.repPhrase.update(
            state.phraseGroupId!,
            state.phraseId!,
            state.phrase,
            state.pronunciation,
            state.definition,
            state.examples,
            state.initial!.rate,
            state.initial!.rates,
            state.initial!.targetUtc,
            state.initial!.createdUtc,
            previousGroupId: state.initial!.groupId);
        if (result != null) {
          svc.route.popWithResult(PhraseEditorPageResult.updated(result));
        }
      }
    }
  }
}
