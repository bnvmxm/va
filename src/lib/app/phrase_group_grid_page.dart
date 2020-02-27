import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => svc.vmPhraseGroupGridPage..initialize(),
      child: Consumer<PhraseGroupGridPageVM>(
        builder: (context, vm, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Collections'),
              actions: _buildAppBarActions(context, vm),
            ),
            body: _buildBody(context, vm)),
      ));

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridPageVM vm) => [
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
                await svc.nav.forwardToEditGroup(vm.phraseGroupSelected.name);
              }),
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: 'Add',
            onPressed: () async {
              await svc.nav.forwardToAddGroup();
            }),
        IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () async {
              await svc.nav.forwardToAbout();
            })
      ];

  Widget _buildBody(BuildContext context, PhraseGroupGridPageVM vm) {
    if (!vm.isReady) {
      return _buildBusyState();
    }

    return vm.isNotEmpty ? PhraseGroupGridView() : _buildEmptyState();
  }

  Widget _buildBusyState() => const Center(child: CircularProgressIndicator());
  Widget _buildEmptyState() => const Center(child: Text('No items...'));
}
