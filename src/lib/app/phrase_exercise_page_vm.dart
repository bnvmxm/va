import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/base_view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseExercisePageArgument {
  PhraseExercisePageArgument(this.groupName, {this.isExerciseFirst = true});
  final String groupName;
  final bool isExerciseFirst;
}

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
    (await svc.logger).debug(() =>
        '${current.phrase}: $curRate -> $newRate, ${curTarget.difference(current.updatedUtc)} -> $newDuration');

    svc.repPhrase.updateStat(groupName, current.id, newRate, newDuration);
    await _fetchNextPhrase();
    isOpen = false;
    isOpening = false;
    invalidate();
  }
}
