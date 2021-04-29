import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_exercise_page_vm.navigation.dart';

class PhraseExercisePageVM extends BaseViewModel<PhraseExercisePageArgument> {
  Phrase? current;
  String? groupName;
  bool isExerciseFirst = true;
  bool isOpen = false;
  bool isOpening = false;

  bool get isAny => current != null;

  @override
  Future Function(PhraseExercisePageArgument? argument) get initializer => (argument) async {
        groupName = argument?.groupName;
        isExerciseFirst = argument?.isExerciseFirst ?? true;
        isOpen = false;
        isOpening = false;
        await _fetchNextPhrase();
      };

  Future _fetchNextPhrase() async {
    current = svc.repPhrase.getForExercise(groupName, exceptId: current?.id);
  }

  void setCardOpening() {
    isOpen = false;
    isOpening = true;
    notifyListeners();
  }

  void setCardOpened() {
    isOpen = true;
    isOpening = false;
    notifyListeners();
  }

  Future next(RateFeedback feedback) async {
    if (!isAny) return;

    final newRate = current!.rate.asRate(feedback);
    final newDuration = newRate.asCooldown(feedback);
    svc.log.d(() => '${current!.phrase}: ${current!.rate} -> $newRate, $newDuration', 'STAT');

    svc.repPhrase.updateStat(groupName, current!.id, newRate, newDuration);
    await _fetchNextPhrase();
    isOpen = false;
    isOpening = false;
    invalidate();
  }
}
