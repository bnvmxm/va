import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/stat_target.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class PhraseGroupGridCard extends StatelessWidget {
  PhraseGroupGridCard(
      {bool? isSelected,
      String? name,
      int? phraseCount,
      DateTime? closeTargetUtc})
      : isSelected = isSelected ?? false,
        name = name ?? '',
        phraseCount = phraseCount ?? 0,
        closeTargetUtc = closeTargetUtc ?? DateTime.now().toUtc();

  final bool isSelected;
  final String name;
  final int phraseCount;
  final DateTime closeTargetUtc;

  @override
  Widget build(BuildContext context) =>
      isSelected ? _buildSelectedCardView(context) : _buildCardView(context);

  Widget _buildSelectedCardView(BuildContext context) =>
      Stack(alignment: AlignmentDirectional.topEnd, children: [
        _buildCardView(context),
        CircleAvatar(
            backgroundColor: VATheme.of(context).colorBackgroundIconSelected,
            radius: 16,
            child: Icon(Icons.check,
                color: VATheme.of(context).colorForegroundIconSelected)),
      ]);

  Widget _buildCardView(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 2, left: 2, bottom: 2, right: 8),
      child: Card(
          elevation: 1.0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isSelected
                    ? VATheme.of(context).colorBackgroundIconSelected
                    : VATheme.of(context).colorBackgroundIconUnselected,
                width: isSelected ? 1.0 : 0.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.topLeft,
                    child: Text(name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: VATheme.of(context).textAccentSubtitle1))),
            Container(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 12.0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      VATheme.of(context).colorBackgroundCard,
                      VATheme.of(context).colorPrimary600
                    ])),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                  Translations.of(context)
                                      .labels
                                      .StatPhrases(count: phraseCount),
                                  style: VATheme.of(context).textCaption)),
                          if (phraseCount > 0)
                            StatTarget(closeTargetUtc.differenceNowUtc()),
                        ]),
                      ),
                    ])),
          ])));
}
