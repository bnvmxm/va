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

  bool get isAny => current != null;

  @override
  Future Function(PhraseExercisePageArgument argument) get initializer => (argument) async {
        groupName = argument.groupName;
        isExerciseFirst = argument.isExerciseFirst;
        await _fetchNextPhrase();
      };

  Future _fetchNextPhrase() async {
    current = svc.repPhrase.getForExercise(groupName);
  }

  Future next(RateFeedback feedback) async {
    assert(isAny);
    final newRate = current.rate.asRate(feedback);
    final newTarget = current.rate.asCooldown(feedback);

    svc.repPhrase.updateStat(groupName, current.id, newRate, newTarget);
    await _fetchNextPhrase();
    invalidate();
  }
}
