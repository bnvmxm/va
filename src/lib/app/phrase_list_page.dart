import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/common/stat_target.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';
import 'package:vocabulary_advancer/core/extensions.dart';

class PhraseListPage extends VAPageWithArgument<String, PhraseListPageVM> {
  PhraseListPage({@required String groupName}) : super(groupName);

  @override
  PhraseListPageVM createVM() => svc.vmPhraseListPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseListPageVM vm) => AppBar(
        title: Text(vm.phraseGroupName, style: VATheme.of(context).textHeadline5),
        actions: _buildAppBarActions(context, vm),
      );

  @override
  Widget buildBody(BuildContext context, PhraseListPageVM vm) {
    return vm.phrases.isNotEmpty
        ? ListView.separated(
            itemCount: vm.phrases.length,
            itemBuilder: (context, i) => _buildPhraseItem(context, vm, i, vm.phrases[i]),
            separatorBuilder: (context, i) => const Divider(indent: 16, endIndent: 16))
        : Empty();
  }

  Widget _buildPhraseItem(BuildContext context, PhraseListPageVM vm, int index, Phrase item) =>
      ListTileTheme(
        selectedColor: VATheme.of(context).colorAccentVariant,
        child: ListTile(
            selected: vm.isSelected(index),
            onTap: () => vm.isSelected(index) ? vm.unselect() : vm.select(index),
            title: Text(item.phrase, style: VATheme.of(context).textBodyText1),
            dense: false,
            leading: vm.isSelected(index)
                ? CircleAvatar(
                    backgroundColor: VATheme.of(context).colorAccentVariant,
                    radius: 12,
                    child: Icon(Icons.check, size: 12, color: VATheme.of(context).colorPrimaryDark))
                : CircleAvatar(
                    backgroundColor: VATheme.of(context).colorPrimaryLight,
                    radius: 12,
                    child:
                        Icon(Icons.check, size: 12, color: VATheme.of(context).colorPrimaryDark)),
            trailing: SizedBox(
              width: 48,
              child: Center(child: StatTarget(item.targetUtc.differenceNowUtc())),
            )),
      );

  List<Widget> _buildAppBarActions(BuildContext context, PhraseListPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit, color: VATheme.of(context).colorAccentVariant),
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
