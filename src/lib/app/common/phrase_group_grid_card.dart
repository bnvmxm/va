import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/stat_target.dart';
import 'package:vocabulary_advancer/core/extensions.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupGridCard extends StatelessWidget {
  PhraseGroupGridCard({bool isSelected, String name, int phraseCount, DateTime closeTargetUtc})
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
            backgroundColor: Theme.of(context).accentColor,
            radius: 16,
            child: Icon(Icons.check, color: Theme.of(context).cardColor)),
      ]);

  Widget _buildCardView(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 2, left: 2, bottom: 2, right: 8),
      child: Card(
          elevation: 1.0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isSelected ? Theme.of(context).accentColor : Theme.of(context).cardColor,
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
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Theme.of(context).secondaryHeaderColor)))),
            Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondaryVariant
                    ])),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Divider(),
                  Row(children: [
                    Expanded(flex: 1, child: _buildCaption(context, svc.i18n.labelsStatPhrases)),
                    Expanded(
                        flex: 1,
                        child: _buildCaption(context, phraseCount.toString(), TextAlign.end))
                  ]),
                  Row(children: [
                    Expanded(
                        child:
                            _buildCaption(context, phraseCount > 0 ? svc.i18n.labelsStatWhen : '')),
                    if (phraseCount > 0) StatTarget(closeTargetUtc.differenceNowUtc())
                  ])
                ])),
          ])));

  Widget _buildCaption(BuildContext context, String caption, [TextAlign align = TextAlign.start]) =>
      Text(caption, textAlign: align, style: Theme.of(context).textTheme.caption);
}
