import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

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
    return ListView.separated(
        itemCount: vm.phrases.length,
        itemBuilder: (context, i) => _buildPhraseItem(context, vm.phrases[i]),
        separatorBuilder: (context, i) => const Divider());
  }

  Widget _buildPhraseItem(BuildContext context, Phrase item) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: Center(child: Text(item.phrase[0].toUpperCase())),
        ),
        title: Text(item.phrase),
      );

  List<Widget> _buildAppBarActions(BuildContext context, PhraseListPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.clear_all),
              tooltip: 'Clear all',
              onPressed: () {
                vm.unselect();
              }),
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () async {
                await vm.navigateToEditPhrase();
              }),
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: 'Add',
            onPressed: () async {
              await vm.navigateToAddPhrase();
            })
      ];
}
