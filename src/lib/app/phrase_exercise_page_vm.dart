import 'package:flutter/foundation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/view_model.dart';

class PhraseExercisePageArgument {
  PhraseExercisePageArgument({@required this.groupName, this.isExerciseFirst = true});
  final String groupName;
  final bool isExerciseFirst;
}

class PhraseExercisePageVM extends BaseViewModel<PhraseExercisePageArgument> {
  Phrase current;

  @override
  Future Function(PhraseExercisePageArgument argument) get initializer =>
      throw UnimplementedError();

  void continieAsLowRate() {}
  void continieAsMediumRate() {}
  void continieAsHighRate() {}
}
