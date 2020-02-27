import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

enum ModelState { unknown, busy, ready }

class PhraseGroupGridPageVM with ChangeNotifier {
  PhraseGroup phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];
  ModelState _state = ModelState.unknown;

  bool get anySelected => _state == ModelState.ready && phraseGroupSelected != null;
  bool get isNotEmpty => _state == ModelState.ready && phraseGroups.isNotEmpty;
  bool get isReady => _state == ModelState.ready;
  ModelState get state => _state;

  Future initialize() async {
    _state = ModelState.busy;
    notifyListeners();

    try {
      phraseGroups = await Future.microtask(() async {
        await Future.delayed(const Duration(milliseconds: 2000)); //TODO: remove
        return svc.repPhraseGroup.findMany().toList();
      });
    } finally {
      _state = ModelState.ready;
      notifyListeners();
    }
  }

  void select(PhraseGroup item) {
    phraseGroupSelected = item;
    notifyListeners();
  }

  void unselect() {
    phraseGroupSelected = null;
    notifyListeners();
  }
}
