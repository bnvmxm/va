import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_vm.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

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
  Widget build(BuildContext context) => BlocBuilder<PhraseGroupGridViewModel, PhraseGroupGridModel>(
      bloc: _vm,
      builder: (context, model) => Scaffold(
            appBar: AppBar(
              title: Text(Translations.of(context).titles.Collections,
                  style: VATheme.of(context).textHeadline5),
              actions: _buildAppBarActions(context, model),
            ),
            body: model.isNotEmpty
                ? PhraseGroupsGrid(model, (item) {
                    _vm.state.isSelected(item) ? _vm.unselect() : _vm.select(item);
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

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridModel model) => [
        if (model.anySelected)
          IconButton(
              icon: Icon(Icons.view_list, color: VATheme.of(context).colorAccentVariant),
              tooltip: Translations.of(context).labels.View,
              onPressed: () async {
                await _vm.navigateToGroup();
              }),
        if (model.anySelected)
          IconButton(
              icon: Icon(Icons.edit, color: VATheme.of(context).colorAccentVariant),
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
