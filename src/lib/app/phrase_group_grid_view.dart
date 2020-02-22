import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_group_card.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shell/root.dart';

class PhraseGroupGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhraseGroupGridViewState();
}

class _PhraseGroupGridViewState extends State<PhraseGroupGridView> {
  String groupNameSelected;

  final Iterable<PhraseGroup> items = groupRepository.findMany();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? _buildGridView(items, isPortrait: true)
          : SafeArea(child: _buildGridView(items, isPortrait: false));
    });
  }

  Widget _buildGridView(Iterable<PhraseGroup> items, {bool isPortrait}) => GridView.count(
      crossAxisCount: isPortrait ? 2 : 3,
      padding: const EdgeInsets.all(8.0),
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: items.map((x) => _buildGridViewTile(x)).toList());

  Widget _buildGridViewTile(PhraseGroup item) => groupNameSelected == item?.name
      ? PhraseGroupCard(name: item.name, isSelected: true)
      : InkWell(
          onTap: () {
            setState(() {
              groupNameSelected = item.name;
            });
          },
          radius: 2,
          child: PhraseGroupCard(name: item.name));
}
