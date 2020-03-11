import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/card_decoration.dart';
import 'package:vocabulary_advancer/app/common/rotatable.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page_vm.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseExercisePage
    extends VAPageWithArgument<PhraseExercisePageArgument, PhraseExercisePageVM> {
  PhraseExercisePage(PhraseExercisePageArgument argument) : super(argument);

  @override
  PhraseExercisePageVM createVM() => svc.vmPhraseExercisePage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseExercisePageVM vm) =>
      AppBar(title: Text(vm.groupName ?? svc.i18n.titlesExercising));

  @override
  Widget buildBody(BuildContext context, PhraseExercisePageVM vm) => vm.isAny
      ? OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? Column(children: [
                  _buildAnimatedCard(context, vm),
                  Expanded(
                    child: _buildExamplesCard(context, vm),
                  ),
                  SizedBox(
                      height: 60,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _buildActionButtons(
                              context, () => const VerticalDivider(indent: 12, endIndent: 24), vm)))
                ])
              : Row(children: [
                  Expanded(child: _buildAnimatedCard(context, vm)),
                  Expanded(child: _buildExamplesCard(context, vm)),
                  SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildActionButtons(
                                context, () => const Divider(indent: 8, endIndent: 24), vm)
                            .reversed
                            .toList(),
                      ))
                ]);
        })
      : _buildEmptyBody(context);

  Widget _buildAnimatedCard(BuildContext context, PhraseExercisePageVM vm) => vm.isOpen
      ? _buildCard(context, vm.current.phrase, isOpen: true)
      : vm.isOpening
          ? Rotatable(
              onRotated: () => vm.setCardOpened(),
              child: _buildCard(context, vm.current.definition, isOpening: true))
          : GestureDetector(
              onTap: () => vm.setCardOpening(),
              child: _buildCard(
                context,
                vm.current.definition,
              ));

  Widget _buildCard(BuildContext context, String value,
          {bool isOpening = false, bool isOpen = false}) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: cardDecoration(context),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Visibility(
                  visible: !isOpening,
                  child: Icon(Icons.mode_comment, color: Theme.of(context).accentColor)),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Visibility(
                        visible: !isOpening,
                        child: Text(value ?? '',
                            style: isOpen
                                ? Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: Theme.of(context).accentColor)
                                : Theme.of(context).textTheme.headline6),
                      )))
            ])),
      );

  Widget _buildExamplesCard(BuildContext context, PhraseExercisePageVM vm) => Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: cardDecoration(context),
            child: ListView.separated(
                itemCount: vm.current.examples.length,
                separatorBuilder: (context, i) => const Divider(indent: 32.0),
                itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(vm.current.examples[i] ?? '',
                          style: Theme.of(context).textTheme.subtitle1),
                    ))),
      );

  List<Widget> _buildActionButtons(
          BuildContext context, Widget Function() divider, PhraseExercisePageVM vm) =>
      [
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultLow,
            icon: Icon(Icons.arrow_downward, color: Theme.of(context).errorColor),
            onPressed: () => vm.next(RateFeedback.lowTheshold)),
        divider(),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultNegative,
            icon: Icon(Icons.trending_down, color: Theme.of(context).dividerColor.withOpacity(1)),
            onPressed: () => vm.next(RateFeedback.negative)),
        divider(),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultUncertain,
            icon: Icon(Icons.trending_flat, color: Theme.of(context).dividerColor.withOpacity(1)),
            onPressed: () => vm.next(RateFeedback.uncertain)),
        divider(),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultPositive,
            icon: Icon(Icons.trending_up, color: Theme.of(context).dividerColor.withOpacity(1)),
            onPressed: () => vm.next(RateFeedback.positive)),
        divider(),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultHigh,
            icon: Icon(Icons.arrow_upward, color: Theme.of(context).accentColor),
            onPressed: () => vm.next(RateFeedback.highThershold))
      ];

  Widget _buildEmptyBody(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16.0), child: Center(child: Text(svc.i18n.textNoPhrase)));
}
