import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/app/services/navigation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_list_page_vm.navigation.dart';

class PhraseListPageVM extends BaseViewModel<String> {
  String phraseGroupName = '';
  int? selectedIndex;
  List<Phrase> phrases = [];

  bool get isNotEmpty => isReady && phrases.isNotEmpty;
  bool get anySelected => selectedIndex != null;

  @override
  Future Function(String? argument) get initializer => (argument) async {
        phraseGroupName = argument ?? '';
        phrases = svc.repPhrase.findMany(phraseGroupName).toList();
      };

  void select(int index) {
    notify(() => selectedIndex = index);
  }

  void unselect() {
    notify(() => selectedIndex = null);
  }

  bool isSelected(int index) => selectedIndex == index;

  Future navigateToAddPhrase() async {
    final result = await forwardToAddPhrase(phraseGroupName);

    if (result?.phrase?.groupName == phraseGroupName) {
      notify(() => phrases.add(result!.phrase!));
    }
  }

  Future navigateToEditPhrase() async {
    assert(selectedIndex != null);
    final selectedPhrase = phrases[selectedIndex!];

    final result = await forwardToEditPhrase(PhraseEditorPageArgument(phraseGroupName,
        id: selectedPhrase.id,
        phrase: selectedPhrase.phrase,
        pronunciation: selectedPhrase.pronunciation,
        definition: selectedPhrase.definition,
        examples: UnmodifiableListView(selectedPhrase.examples)));

    if (result == null) return;

    if (!result.isDeleted && result.phrase?.groupName == phraseGroupName) {
      notify(() => phrases[selectedIndex!] = result.phrase!);
    } else {
      notify(() {
        phrases.removeAt(selectedIndex!);
        selectedIndex = null;
      });
    }
  }
}
