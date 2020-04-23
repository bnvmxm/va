import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

part 'phrase_exercise_page_vm.navigation.dart';

class PhraseExercisePageVM extends BaseViewModel<PhraseExercisePageArgument> {
  Phrase current;
  String groupName;
  bool isExerciseFirst;
  bool isOpen;
  bool isOpening;

  bool get isAny => current != null;

  @override
  Future Function(PhraseExercisePageArgument argument) get initializer => (argument) async {
        groupName = argument.groupName;
        isExerciseFirst = argument.isExerciseFirst;
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
    assert(isAny);

    final curRate = current.rate;
    final curTarget = current.targetUtc;
    final newRate = current.rate.asRate(feedback);
    final newDuration = newRate.asCooldown(feedback);
    svc.logger.debug(() =>
        '${current.phrase}: $curRate -> $newRate, ${curTarget.difference(current.updatedUtc)} -> $newDuration');

    svc.repPhrase.updateStat(groupName, current.id, newRate, newDuration);
    await _fetchNextPhrase();
    isOpen = false;
    isOpening = false;
    invalidate();
  }
}
