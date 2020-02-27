import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_card.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';

class PhraseGroupGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhraseGroupGridViewState();
}

class _PhraseGroupGridViewState extends State<PhraseGroupGridView> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? _buildGridView(isPortrait: true)
          : SafeArea(child: _buildGridView(isPortrait: false));
    });
  }

  Widget _buildGridView({bool isPortrait}) => Consumer<PhraseGroupGridPageVM>(
      builder: (context, vm, child) => GridView.count(
          crossAxisCount: isPortrait ? 2 : 3,
          padding: const EdgeInsets.all(8.0),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: vm.phraseGroups
              .map((x) => _buildGridViewTile(vm, x, isSelected: x == vm.phraseGroupSelected))
              .toList()));

  Widget _buildGridViewTile(PhraseGroupGridPageVM vm, PhraseGroup item, {bool isSelected}) =>
      isSelected
          ? PhraseGroupGridCard(name: item.name, isSelected: true)
          : InkWell(
              onTap: () {
                vm.select(item);
              },
              radius: 2,
              child: PhraseGroupGridCard(name: item.name));
}
