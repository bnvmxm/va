import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid_card.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';

class PhraseGroupsGrid extends StatelessWidget {
  final PhraseGroupGridModel _model;
  final void Function(PhraseGroup) onPhraseGroupTap;

  PhraseGroupsGrid(this._model, this.onPhraseGroupTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => OrientationBuilder(
      builder: (context, orientation) => orientation == Orientation.portrait
          ? _buildGridView(isPortrait: true)
          : SafeArea(child: _buildGridView(isPortrait: false)));

  Widget _buildGridView({required bool isPortrait}) => GridView.count(
      crossAxisCount: isPortrait ? 1 : 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: isPortrait ? 2 : 1.8,
      padding: const EdgeInsets.all(8.0),
      children: _model.phraseGroups.map(_buildGridViewTile).toList());

  Widget _buildGridViewTile(PhraseGroup item) => GestureDetector(
      onTap: () {
        onPhraseGroupTap(item);
      },
      child: PhraseGroupGridCard(
          name: item.name,
          phraseCount: item.phraseCount,
          closeTargetUtc: item.closeTargetUtc,
          isSelected: _model.isSelected(item)));
}
