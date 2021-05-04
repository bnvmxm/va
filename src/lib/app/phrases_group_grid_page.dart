import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid_card.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_vm.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/core/model.dart';

class PhraseGroupGridPage extends StatefulWidget {
  @override
  _PhraseGroupGridPageState createState() => _PhraseGroupGridPageState();
}

class _PhraseGroupGridPageState extends State<PhraseGroupGridPage> {
  late PhraseGroupGridViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = PhraseGroupGridViewModel()..init();
  }

  @override
  void dispose() {
    _vm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PhraseGroupGridViewModel, PhraseGroupGridModel>(
          bloc: _vm,
          builder: (context, model) => Scaffold(
                appBar: AppBar(
                  title: Text(Translations.of(context).titles.Collections,
                      style: VATheme.of(context).textHeadline5),
                  actions: _buildAppBarActions(context, model),
                ),
                body: model.isNotEmpty
                    ? PhraseGroupsGrid(model, (item) {
                        _vm.state.isSelected(item)
                            ? _vm.unselect()
                            : _vm.select(item);
                      })
                    : Empty(),
                floatingActionButton: model.anySelected
                    ? FloatingActionButton(
                        tooltip: Translations.of(context).labels.Exercise,
                        backgroundColor: model.anySelectedAndNotEmpty
                            ? VATheme.of(context).colorAccentVariant
                            : VATheme.of(context).colorBackgroundCard,
                        foregroundColor: model.anySelectedAndNotEmpty
                            ? VATheme.of(context).colorPrimaryDark
                            : VATheme.of(context).colorPrimaryLight,
                        onPressed: () async {
                          await _vm.navigateToExercise();
                        },
                        child: Icon(Icons.view_carousel))
                    : null,
              ));

  List<Widget> _buildAppBarActions(
          BuildContext context, PhraseGroupGridModel model) =>
      [
        if (model.anySelected)
          IconButton(
              icon: Icon(Icons.view_list,
                  color: VATheme.of(context).colorAccentVariant),
              tooltip: Translations.of(context).labels.View,
              onPressed: () async {
                await _vm.navigateToGroup();
              }),
        if (model.anySelected)
          IconButton(
              icon: Icon(Icons.edit,
                  color: VATheme.of(context).colorAccentVariant),
              tooltip: Translations.of(context).labels.Edit,
              onPressed: () async {
                await _vm.navigateToEditGroup();
              }),
        if (!model.anySelected)
          IconButton(
              icon: Icon(Icons.plus_one),
              tooltip: Translations.of(context).labels.Add,
              onPressed: () async {
                await _vm.navigateToAddGroup();
              }),
        PopupMenuButton<int>(
          onSelected: (index) async => _onActionSelected(index),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.language),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(Translations.of(context).labels.Language),
                    )
                  ],
                )),
            PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.info),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(Translations.of(context).labels.About),
                    )
                  ],
                ))
          ],
        ),
      ];

  Future _onActionSelected(int index) async {
    switch (index) {
      case 1:
        return _vm.nextLanguage();
      case 2:
        return _vm.navigateToAbout();
    }
  }
}

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
