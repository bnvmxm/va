import 'package:flutter/material.dart';
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
    return ListView.separated(
        itemCount: vm.phrases.length,
        itemBuilder: (context, i) => _buildPhraseItem(context, vm.phrases[i]),
        separatorBuilder: (context, i) => const Divider());
  }

  Widget _buildPhraseItem(BuildContext context, Phrase item) => ListTile(
        title: Text(item.phrase),
        subtitle: Text(item.definition),
        isThreeLine: true,
        trailing: SizedBox(
          width: 70,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Rate: ${item.rate}', style: Theme.of(context).textTheme.caption),
            const SizedBox(height: 6),
            Text(item.targetUtc.toLocal().toStringAsTarget(),
                style: Theme.of(context).textTheme.caption)
          ]),
        ),
      );

  List<Widget> _buildAppBarActions(BuildContext context, PhraseListPageVM vm) => [
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: 'Add',
            onPressed: () async {
              await vm.navigateToAddPhrase();
            })
      ];
}
