import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/stat_target.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class PhraseListPage extends VAPageWithArgument<String, PhraseListPageVM> {
  PhraseListPage({@required String groupName}) : super(groupName);

  @override
  PhraseListPageVM createVM() => svc.vmPhraseListPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseListPageVM vm) => AppBar(
        title: Text(vm.phraseGroupName),
        actions: _buildAppBarActions(context, vm),
      );

  @override
  Widget buildBody(BuildContext context, PhraseListPageVM vm) {
    return vm.phrases.isNotEmpty
        ? ListView.separated(
            itemCount: vm.phrases.length,
            itemBuilder: (context, i) => _buildSelectedPhraseItem(context, vm, i, vm.phrases[i]),
            separatorBuilder: (context, i) => const Divider())
        : buildEmptyBody(context);
  }

  Widget _buildSelectedPhraseItem(
          BuildContext context, PhraseListPageVM vm, int index, Phrase item) =>
      vm.isSelected(index)
          ? Stack(alignment: AlignmentDirectional.topStart, children: [
              Transform.scale(
                  scale: 0.85, child: _buildPhraseItem(context, vm, index, item, withStat: false)),
              Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                  child: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 12,
                      child: Icon(Icons.check, color: Theme.of(context).cardColor))),
            ])
          : _buildPhraseItem(context, vm, index, item);

  Widget _buildPhraseItem(BuildContext context, PhraseListPageVM vm, int index, Phrase item,
          {bool withStat = true}) =>
      ListTile(
        selected: vm.isSelected(index),
        onLongPress: () => vm.select(index),
        onTap: () => vm.unselect(),
        title: Text(item.phrase),
        subtitle: Text(item.definition),
        isThreeLine: true,
        trailing:
            withStat && (item.rate.isRateLow() || item.targetUtc.differenceNowUtc().isTargetClose())
                ? SizedBox(
                    width: 60,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [StatTarget(item.targetUtc.differenceNowUtc())]),
                  )
                : null,
      );

  List<Widget> _buildAppBarActions(BuildContext context, PhraseListPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: svc.i18n.labelsEdit,
              onPressed: () async {
                await vm.navigateToEditPhrase();
              }),
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: svc.i18n.labelsAdd,
            onPressed: () async {
              await vm.navigateToAddPhrase();
            })
      ];
}
