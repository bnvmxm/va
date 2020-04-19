import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/rotatable.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
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
  AppBar buildAppBar(BuildContext context, PhraseExercisePageVM vm) => AppBar(
      title: Text(vm.groupName ?? svc.i18n.titlesExercising,
          style: VATheme.of(context).textHeadline5));

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
                          children: _buildActionButtons(context, true, vm)))
                ])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _buildAnimatedCard(context, vm)),
                  Expanded(child: _buildExamplesCard(context, vm)),
                  SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildActionButtons(context, false, vm).reversed.toList(),
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
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: cardDecoration(context),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Visibility(
                  visible: !isOpening,
                  child: Icon(Icons.mode_comment,
                      color: isOpen
                          ? VATheme.of(context).colorAccentVariant
                          : VATheme.of(context).colorForeground)),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Visibility(
                        visible: !isOpening,
                        child: Text(value ?? '',
                            style: isOpen
                                ? VATheme.of(context).textAccentHeadline5
                                : VATheme.of(context).textSubtitle2),
                      )))
            ])),
      );

  Widget _buildExamplesCard(BuildContext context, PhraseExercisePageVM vm) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: cardDecoration(context),
            child: ListView.separated(
                itemCount: vm.current.examples.length,
                separatorBuilder: (context, i) => const Divider(indent: 8.0, endIndent: 8.0),
                itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(vm.current.examples[i] ?? '',
                          style: VATheme.of(context).textBodyText2),
                    ))),
      );

  List<Widget> _buildActionButtons(
          BuildContext context, bool withDivider, PhraseExercisePageVM vm) =>
      [
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultLow,
            icon: Icon(Icons.arrow_downward, color: VATheme.of(context).colorAttention),
            onPressed: () => vm.next(RateFeedback.lowTheshold)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultNegative,
            icon: Icon(Icons.trending_down, color: VATheme.of(context).colorForeground),
            onPressed: () => vm.next(RateFeedback.negative)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultUncertain,
            icon: Icon(Icons.trending_flat, color: VATheme.of(context).colorForeground),
            onPressed: () => vm.next(RateFeedback.uncertain)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultPositive,
            icon: Icon(Icons.trending_up, color: VATheme.of(context).colorForeground),
            onPressed: () => vm.next(RateFeedback.positive)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: svc.i18n.labelsExerciseResultHigh,
            icon: Icon(Icons.arrow_upward, color: VATheme.of(context).colorAccentVariant),
            onPressed: () => vm.next(RateFeedback.highThershold))
      ];

  Widget _buildEmptyBody(BuildContext context) => Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline,
                size: 32, color: VATheme.of(context).colorAccentVariant),
            const SizedBox(height: 16.0),
            Text(svc.i18n.textNoPhrase),
          ]));
}
