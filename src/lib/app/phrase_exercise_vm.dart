import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseExerciseModel {
  bool isLoading = true;
  bool isOpen = false;
  bool isAnimated = false;
  Phrase? current;
  int countTargeted = 0;
  bool isExerciseFirst = true;
  final String groupId;

  bool get isAny => current != null;

  PhraseExerciseModel(this.groupId);

  PhraseExerciseModel.empty(this.groupId)
      : isAnimated = false,
        isOpen = false,
        isLoading = false,
        current = null,
        countTargeted = 0,
        isExerciseFirst = true;

  PhraseExerciseModel.from(
    PhraseExerciseModel model, {
    bool? isLoading,
    bool? isOpen,
    bool? isAnimated,
    Phrase? current,
    int? countTargeted,
    String? groupName,
    bool? isExerciseFirst,
  }) : groupId = model.groupId {
    this.isOpen = isOpen ?? model.isOpen;
    this.isAnimated = isAnimated ?? model.isAnimated;
    this.isLoading = isLoading ?? model.isLoading;
    this.current = current ?? model.current;
    this.countTargeted = countTargeted ?? model.countTargeted;
    this.isExerciseFirst = isExerciseFirst ?? model.isExerciseFirst;
  }
}

class PhraseExerciseViewModel extends Cubit<PhraseExerciseModel> {
  PhraseExerciseViewModel(String groupId) : super(PhraseExerciseModel(groupId));

  void init() {
    svc.userService.trackScreen(runtimeType.toString());
    _setNextPhrase();
  }

  void animateCard() {
    state.isAnimated = true;
    emit(PhraseExerciseModel.from(state));
  }

  void rotateCard() {
    state.isAnimated = false;
    emit(PhraseExerciseModel.from(state, isOpen: !state.isOpen));
  }

  Future next(RateFeedback feedback) async {
    if (!state.isAny) return;

    final newRate = state.current!.rate.asRate(feedback);
    final newDuration = newRate.asCooldown(feedback);
    final current = state.current!;
    svc.userService.trackEvent("stat", {
      "phrase": current.phrase,
      "rate": newRate,
      "duration": newDuration,
    });

    final arr = current.rates;
    while (arr.length > 10) {
      arr.removeAt(0);
    }

    await svc.repPhrase.update(
        current.groupId,
        current.id,
        current.phrase,
        current.pronunciation,
        current.definition,
        current.examples,
        newRate,
        arr..add(newRate),
        DateTime.now().toUtc().add(newDuration),
        current.createdUtc);

    await _setNextPhrase();
  }

  Future<void> _setNextPhrase() async {
    final exercise =
        await svc.repPhrase.getExerciseByGroup(state.groupId, exceptPhraseId: state.current?.id);

    emit(exercise.phrase == null
        ? PhraseExerciseModel.empty(state.groupId)
        : PhraseExerciseModel.from(
            state,
            current: exercise.phrase,
            countTargeted: exercise.countTargeted,
            isLoading: false,
            isOpen: false,
            isAnimated: false,
          ));
  }
}
