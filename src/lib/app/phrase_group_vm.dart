import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shell/root.dart';

class PhraseGroupViewModel with ChangeNotifier {
  final _repository = groupRepository;

  PhraseGroup phraseGroupSelected;
  List<PhraseGroup> phraseGroups = [];

  bool get anySelected => phraseGroupSelected != null;
  bool get isNotEmpty => phraseGroups.isNotEmpty;

  Future initialize() async {
    phraseGroups = await Future.microtask(() {
      return _repository.findMany().toList();
    });
    notifyListeners();
  }

  void select(PhraseGroup item) {
    phraseGroupSelected = item;
    notifyListeners();
  }
}
