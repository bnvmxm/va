import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:vocabulary_advancer/core/base_view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseEditorPageArgument {
  PhraseEditorPageArgument(this.phraseGroupName,
      {this.id, this.phrase, this.definition, this.pronunciation, this.examples});
  final String phraseGroupName;
  final String id;
  final String phrase;
  final String definition;
  final String pronunciation;
  final UnmodifiableListView<String> examples;
}

class PhraseEditorPageVM extends BaseViewModel<PhraseEditorPageArgument> {
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
  bool _needInlineValidation = false;

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

  bool validate(bool Function() validator) {
    _needInlineValidation = !validator();
    return !_needInlineValidation;
  }

  void _validateInlineIfNeeded(bool Function() validator) {
    if (_needInlineValidation && validator()) {
      _needInlineValidation = false;
    }
  }

  void updateGroupName(String value) {
    notify(() => phraseGroupName = value);
  }

  void updatePhrase(String value, bool Function() validator) {
    phrase = value;
    _validateInlineIfNeeded(validator);
  }

  void updatePronunciation(String value, bool Function() validator) {
    pronunciation = value;
    _validateInlineIfNeeded(validator);
  }

  void updateDefinition(String value, bool Function() validator) {
    definition = value;
    _validateInlineIfNeeded(validator);
  }

  void addExample(String value, bool Function() validator) {
    if (value?.isNotEmpty ?? false) {
      notify(() => examples.add(value));
      _validateInlineIfNeeded(validator);
    }
  }

  void removeExample(int index) {
    notify(() => examples.removeAt(index));
  }

  String validationMessageWhenEmpty({@required String value, @required String Function() onEmpty}) {
    final val = value.trim();

    if (val.isEmpty) return onEmpty();
    return null;
  }

  String validationMessageForExamples({@required String Function() onEmpty}) {
    if (examples.isEmpty) {
      return onEmpty();
    }

    return null;
  }

  void applyAndClose() {
    assert(phraseGroupName.isNotEmpty);

    final result = isNewPhrase
        ? svc.repPhrase.create(phraseGroupName, phrase, pronunciation, definition, examples)
        : svc.repPhrase.update(initialValues.phraseGroupName, phraseGroupName, id, phrase,
            pronunciation, definition, examples);

    svc.nav.backWithResult(result);
  }
}
