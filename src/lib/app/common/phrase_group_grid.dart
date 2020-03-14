import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid_card.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';

class PhraseGroupGridView extends StatelessWidget {
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
          crossAxisCount: isPortrait ? 1 : 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: isPortrait ? 2 : 1.6,
          padding: const EdgeInsets.all(8.0),
          children: vm.phraseGroups.map((x) => _buildGridViewTile(vm, x)).toList()));

  Widget _buildGridViewTile(PhraseGroupGridPageVM vm, PhraseGroup item) => GestureDetector(
      onTap: () async {
        vm.isSelected(item) ? vm.unselect() : vm.select(item);
      },
      child: PhraseGroupGridCard(
          name: item.name,
          phraseCount: item.phraseCount,
          closeTargetUtc: item.closeTargetUtc,
          isSelected: vm.isSelected(item)));
}
