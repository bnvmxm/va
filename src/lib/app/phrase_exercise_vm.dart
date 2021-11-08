import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseExerciseModel {
  bool isLoading = true;
  bool isOpen = false;
  bool isAnimated = false;
  Phrase? current;
  String groupName = '';
  bool isExerciseFirst = true;
  final String groupId;

  bool get isAny => current != null;

  PhraseExerciseModel(this.groupId);

  PhraseExerciseModel.from(
    PhraseExerciseModel model, {
    bool? isLoading,
    bool? isOpen,
    bool? isOpening,
    Phrase? current,
    String? groupName,
    bool? isExerciseFirst,
  }) : groupId = model.groupId {
    isAnimated = isOpening ?? model.isAnimated;
    this.isOpen = isOpen ?? model.isOpen;
    this.isLoading = isLoading ?? model.isLoading;
    this.current = current ?? model.current;
    this.groupName = groupName ?? model.groupName;
    this.isExerciseFirst = isExerciseFirst ?? model.isExerciseFirst;
  }
}

class PhraseExerciseViewModel extends Cubit<PhraseExerciseModel> {
  PhraseExerciseViewModel(String groupId) : super(PhraseExerciseModel(groupId));

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
    svc.log.d(() => '${current.phrase}: ${current.rate} -> $newRate, $newDuration');

    await svc.repPhrase.update(
        current.groupId,
        current.id,
        current.phrase,
        current.pronunciation,
        current.definition,
        current.examples,
        newRate,
        current.rates..add(newRate),
        DateTime.now().toUtc().add(newDuration),
        current.createdUtc);

    await _setNextPhrase();
  }

  Future<void> _setNextPhrase() async {
    state.current =
        await svc.repPhrase.getExerciseByGroup(state.groupId, exceptPhraseId: state.current?.id);

    emit(PhraseExerciseModel.from(
      state,
      isLoading: false,
      isOpen: false,
      isOpening: false,
    ));
  }
}
