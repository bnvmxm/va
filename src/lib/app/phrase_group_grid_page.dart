import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupGridPage extends VAPage<PhraseGroupGridPageVM> {
  @override
  PhraseGroupGridPageVM createVM() => svc.vmPhraseGroupGridPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseGroupGridPageVM vm) => AppBar(
        title: const Text('Collections'),
        actions: _buildAppBarActions(context, vm),
      );

  @override
  Widget buildBody(BuildContext context, PhraseGroupGridPageVM vm) =>
      vm.isNotEmpty ? PhraseGroupGridView() : _buildBodyWhenEmpty();

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.play_arrow),
              tooltip: 'View',
              onPressed: () {
                vm.navigateToGroup();
              }),
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () async {
                await vm.navigateToEditGroup();
              }),
        IconButton(
            icon: Icon(Icons.plus_one),
            tooltip: 'Add',
            onPressed: () async {
              await vm.navigateToAddGroup();
            }),
        IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () async {
              await vm.navigateToAbout();
            })
      ];

  Widget _buildBodyWhenEmpty() => const Center(child: Text('No Items...'));
}
