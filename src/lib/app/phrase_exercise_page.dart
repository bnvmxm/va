import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseExercisePage
    extends VAPageWithArgument<PhraseExercisePageArgument, PhraseExercisePageVM> {
  PhraseExercisePage({PhraseExercisePageArgument argument}) : super(argument);

  @override
  PhraseExercisePageVM createVM() => svc.vmPhraseExercisePage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseExercisePageVM vm) =>
      AppBar(title: Text(svc.i18n.titlesExercising));

  @override
  Widget buildBody(BuildContext context, PhraseExercisePageVM vm) => Column(children: [
        Expanded(child: Center(child: Text(vm.current?.definition))),
        SizedBox(
            height: 80,
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: RaisedButton(
                      onPressed: () => vm.continieAsLowRate(), child: const Text('+1m'))),
              Expanded(
                  flex: 1,
                  child: RaisedButton(
                      onPressed: () => vm.continieAsMediumRate(), child: const Text('+2h'))),
              Expanded(
                  flex: 1,
                  child: RaisedButton(
                      onPressed: () => vm.continieAsHighRate(), child: const Text('>>>'))),
            ]))
      ]);
}
