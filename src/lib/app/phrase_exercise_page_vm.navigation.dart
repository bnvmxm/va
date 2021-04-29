part of 'phrase_exercise_page_vm.dart';

Route routePhraseExercisePage(PhraseExercisePageArgument argument) =>
    MaterialPageRoute<void>(builder: (context) => PhraseExercisePage(argument));

class PhraseExercisePageArgument {
  PhraseExercisePageArgument(this.groupName, {this.isExerciseFirst = true});
  final String groupName;
  final bool isExerciseFirst;
}
