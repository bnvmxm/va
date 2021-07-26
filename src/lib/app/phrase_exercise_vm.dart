import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

part 'phrase_exercise_vm.nav.dart';

class PhraseExerciseModel {
  bool isLoading = true;
  bool isOpen = false;
  bool isAnimated = false;
  Phrase? current;
  String groupName = '';
  bool isExerciseFirst = true;

  bool get isAny => current != null;

  PhraseExerciseModel.fromArgument(PhraseExercisePageArgument arg) {
    groupName = arg.groupName;
    isExerciseFirst = arg.isExerciseFirst;
  }

  PhraseExerciseModel.from(
    PhraseExerciseModel model, {
    bool? isLoading,
    bool? isOpen,
    bool? isOpening,
    Phrase? current,
    String? groupName,
    bool? isExerciseFirst,
  }) {
    isAnimated = isOpening ?? model.isAnimated;
    this.isOpen = isOpen ?? model.isOpen;
    this.isLoading = isLoading ?? model.isLoading;
    this.current = current ?? model.current;
    this.groupName = groupName ?? model.groupName;
    this.isExerciseFirst = isExerciseFirst ?? model.isExerciseFirst;
  }
}

class PhraseExerciseViewModel extends Cubit<PhraseExerciseModel> {
  PhraseExerciseViewModel(PhraseExercisePageArgument arg)
      : super(PhraseExerciseModel.fromArgument(arg));

  void init() => _setNextPhrase();

  void animateCard() {
    state.isAnimated = true;
    emit(PhraseExerciseModel.from(state));
  }

  void rotateCard() {
    state.isOpen = !state.isOpen;
    state.isAnimated = false;
    emit(PhraseExerciseModel.from(state));
  }

  Future next(RateFeedback feedback) async {
    if (!state.isAny) return;

    final newRate = state.current!.rate.asRate(feedback);
    final newDuration = newRate.asCooldown(feedback);
    final current = state.current!;
    svc.log.d(
        () => '${current.phrase}: ${current.rate} -> $newRate, $newDuration');

    svc.repPhrase
        .updateStat(state.groupName, state.current!.id, newRate, newDuration);

    await _setNextPhrase();
  }

  Future _setNextPhrase() async {
    state.current = svc.repPhrase
        .getForExercise(state.groupName, exceptId: state.current?.id);

    emit(PhraseExerciseModel.from(
      state,
      isLoading: false,
      isOpen: false,
      isOpening: false,
    ));
  }
}
