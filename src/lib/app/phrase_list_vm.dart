import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/phrase_editor_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_list_vm.nav.dart';

class PhraseListModel {
  bool isLoading = true;
  String phraseGroupName = '';
  List<Phrase> phrases = [];
  int? selectedIndex;

  bool get isNotEmpty => phrases.isNotEmpty;
  bool get anySelected => selectedIndex != null;
  bool isSelected(int index) => selectedIndex == index;

  PhraseListModel(this.phraseGroupName);

  PhraseListModel.from(
    PhraseListModel model, {
    bool? isLoading,
    String? phraseGroupName,
    List<Phrase>? phrases,
    int? selectedIndex,
  }) {
    this.isLoading = isLoading ?? model.isLoading;
    this.phraseGroupName = phraseGroupName ?? model.phraseGroupName;
    this.phrases = phrases ?? model.phrases;
    this.selectedIndex = selectedIndex ?? model.selectedIndex;
  }
}

class PhraseListViewModel extends Cubit<PhraseListModel> {
  PhraseListViewModel(String phraseGroupName)
      : super(PhraseListModel(phraseGroupName));

  void init() {
    emit(PhraseListModel.from(state,
        isLoading: false,
        phrases: svc.repPhrase.findMany(state.phraseGroupName).toList()));
  }

  void select(int index) {
    emit(PhraseListModel.from(state, selectedIndex: index));
  }

  void unselect() {
    state.selectedIndex = null;
    emit(PhraseListModel.from(state));
  }

  Future navigateToAddPhrase() async {
    final result = await forwardToAddPhrase(state.phraseGroupName);

    if (result?.phrase?.groupName == state.phraseGroupName) {
      emit(PhraseListModel.from(state,
          phrases: state.phrases..add(result!.phrase!)));
    }
  }

  Future navigateToEditPhrase() async {
    assert(state.selectedIndex != null);
    final selectedPhrase = state.phrases[state.selectedIndex!];

    final result = await forwardToEditPhrase(PhraseEditorPageArgument(
        state.phraseGroupName,
        id: selectedPhrase.id,
        phrase: selectedPhrase.phrase,
        pronunciation: selectedPhrase.pronunciation,
        definition: selectedPhrase.definition,
        examples: UnmodifiableListView(selectedPhrase.examples)));

    if (result == null) return;

    if (!result.isDeleted &&
        result.phrase?.groupName == state.phraseGroupName) {
      state.phrases[state.selectedIndex!] = result.phrase!;
    } else {
      // Deleted or moved to another collection
      state.phrases.removeAt(state.selectedIndex!);
    }

    emit(PhraseListModel.from(state));
  }
}
