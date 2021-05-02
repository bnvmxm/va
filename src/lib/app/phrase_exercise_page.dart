import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/rotatable.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_vm.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/model.dart';

class PhraseExercisePage extends StatefulWidget {
  final PhraseExercisePageArgument arg;

  PhraseExercisePage(this.arg);

  @override
  _PhraseExercisePageState createState() => _PhraseExercisePageState();
}

class _PhraseExercisePageState extends State<PhraseExercisePage> {
  late PhraseExerciseViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = PhraseExerciseViewModel(widget.arg)..init();
  }

  @override
  void dispose() {
    _vm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PhraseExerciseViewModel, PhraseExerciseModel>(
          bloc: _vm,
          builder: (context, model) => Scaffold(
                appBar: model.isLoading
                    ? null
                    : AppBar(
                        title: Text(model.groupName,
                            style: VATheme.of(context).textHeadline5)),
                body: model.isLoading
                    ? CircularProgressIndicator()
                    : model.isAny
                        ? OrientationBuilder(
                            builder: (context, orientation) => orientation ==
                                    Orientation.portrait
                                ? Column(children: [
                                    _buildAnimatedCard(context, model),
                                    Expanded(
                                      child: _buildExamplesCard(context, model),
                                    ),
                                    SizedBox(
                                        height: 60,
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: _buildActionButtons(
                                                context, true, model)))
                                  ])
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Expanded(
                                            child: _buildAnimatedCard(
                                                context, model)),
                                        Expanded(
                                            child: _buildExamplesCard(
                                                context, model)),
                                        SizedBox(
                                            width: 60,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: _buildActionButtons(
                                                      context, false, model)
                                                  .reversed
                                                  .toList(),
                                            ))
                                      ]))
                        : _buildEmptyBody(context),
              ));

  Widget _buildAnimatedCard(BuildContext context, PhraseExerciseModel model) =>
      model.isOpen
          ? _buildCard(context, model.current!.phrase, isOpen: true)
          : model.isOpening
              ? Rotatable(
                  onRotated: () => _vm.setCardOpened(),
                  child: _buildCard(context, model.current!.definition,
                      isOpening: true))
              : GestureDetector(
                  onTap: () => _vm.setCardOpening(),
                  child: _buildCard(
                    context,
                    model.current!.definition,
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
                        child: Text(value,
                            style: isOpen
                                ? VATheme.of(context).textAccentHeadline5
                                : VATheme.of(context).textSubtitle2),
                      )))
            ])),
      );

  Widget _buildExamplesCard(BuildContext context, PhraseExerciseModel model) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: cardDecoration(context),
            child: ListView.separated(
                itemCount: model.current!.examples.length,
                separatorBuilder: (context, i) =>
                    const Divider(indent: 8.0, endIndent: 8.0),
                itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.current!.examples[i],
                          style: VATheme.of(context).textBodyText2),
                    ))),
      );

  List<Widget> _buildActionButtons(
          BuildContext context, bool withDivider, PhraseExerciseModel model) =>
      [
        IconButton(
            iconSize: 24,
            tooltip: Translations.of(context).labels.ExerciseResult.Low,
            icon: Icon(Icons.arrow_downward,
                color: VATheme.of(context).colorAttention),
            onPressed: () => _vm.next(RateFeedback.lowTheshold)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: Translations.of(context).labels.ExerciseResult.Negative,
            icon: Icon(Icons.trending_down,
                color: VATheme.of(context).colorForeground),
            onPressed: () => _vm.next(RateFeedback.negative)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: Translations.of(context).labels.ExerciseResult.Uncertain,
            icon: Icon(Icons.trending_flat,
                color: VATheme.of(context).colorForeground),
            onPressed: () => _vm.next(RateFeedback.uncertain)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: Translations.of(context).labels.ExerciseResult.Positive,
            icon: Icon(Icons.trending_up,
                color: VATheme.of(context).colorForeground),
            onPressed: () => _vm.next(RateFeedback.positive)),
        if (withDivider) const VerticalDivider(indent: 12, endIndent: 24),
        IconButton(
            iconSize: 24,
            tooltip: Translations.of(context).labels.ExerciseResult.High,
            icon: Icon(Icons.arrow_upward,
                color: VATheme.of(context).colorAccentVariant),
            onPressed: () => _vm.next(RateFeedback.highThershold))
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
            Text(Translations.of(context).text.NoPhrase),
          ]));
}
