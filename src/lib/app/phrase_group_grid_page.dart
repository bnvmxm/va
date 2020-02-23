import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_model.dart';
import 'package:vocabulary_advancer/shell/root.dart';
import 'package:vocabulary_advancer/app/va_app/nav.dart';

class PhraseGroupGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => phraseGroupGridPageModel..initialize(),
      child: Consumer<PhraseGroupGridPageModel>(
        builder: (context, vm, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Collections'),
              actions: _buildAppBarActions(context, vm),
            ),
            body: _buildBody(context, vm)),
      ));

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridPageModel vm) => [
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
                await pushToEditGroup(context, vm.phraseGroupSelected.name);
              }),
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: 'Add',
            onPressed: () async {
              await pushToAddGroup(context);
            }),
        IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () async {
              await pushToAbout(context);
            })
      ];

  Widget _buildBody(BuildContext context, PhraseGroupGridPageModel vm) {
    if (!vm.isReady) {
      return _buildBusyState();
    }

    return vm.isNotEmpty ? PhraseGroupGridView() : _buildEmptyState();
  }

  Widget _buildBusyState() => const Center(child: CircularProgressIndicator());
  Widget _buildEmptyState() => const Center(child: Text('No items...'));
}
