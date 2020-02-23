import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrase_group_vm.dart';

class PhraseGroupGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => PhraseGroupViewModel()..initialize(),
      child: Consumer<PhraseGroupViewModel>(
        builder: (context, vm, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Collections'),
              actions: vm.anySelected ? _buildAppBarActions() : null,
            ),
            body: vm.isNotEmpty ? PhraseGroupGridView() : _buildEmptyState()),
      ));

  List<Widget> _buildAppBarActions() => [
        IconButton(icon: Icon(Icons.clear_all), tooltip: 'Clear all', onPressed: () {}),
        IconButton(icon: Icon(Icons.add), tooltip: 'Add', onPressed: () {})
      ];

  Widget _buildEmptyState() => const Center(child: Text('No items...'));
}
