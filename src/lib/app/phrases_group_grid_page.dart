import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupGridPage extends VAPage<PhraseGroupGridPageVM> {
  @override
  PhraseGroupGridPageVM createVM() => svc.vmPhraseGroupGridPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseGroupGridPageVM vm) => AppBar(
        title: Text(svc.i18n.titlesCollections, style: VATheme.of(context).textHeadline5),
        actions: _buildAppBarActions(context, vm),
      );

  @override
  Widget buildBody(BuildContext context, PhraseGroupGridPageVM vm) =>
      vm.isNotEmpty ? PhraseGroupGridView() : Empty();

  @override
  Widget buildFAB(BuildContext context, PhraseGroupGridPageVM vm) => vm.anySelected
      ? FloatingActionButton(
          tooltip: svc.i18n.labelsExercise,
          backgroundColor: vm.anySelectedAndNotEmpty
              ? VATheme.of(context).colorAccentVariant
              : VATheme.of(context).colorBackgroundCard,
          foregroundColor: vm.anySelectedAndNotEmpty
              ? VATheme.of(context).colorPrimaryDark
              : VATheme.of(context).colorPrimaryLight,
          onPressed: () async {
            await vm.navigateToExercise();
          },
          child: Icon(Icons.view_carousel))
      : null;

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.view_list,
                  color: vm.anySelectedAndNotEmpty
                      ? VATheme.of(context).colorAccentVariant
                      : VATheme.of(context).colorPrimaryLight),
              tooltip: svc.i18n.labelsView,
              onPressed: () async {
                await vm.navigateToGroup();
              }),
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit, color: VATheme.of(context).colorAccentVariant),
              tooltip: svc.i18n.labelsEdit,
              onPressed: () async {
                await vm.navigateToEditGroup();
              }),
        if (!vm.anySelected)
          IconButton(
              icon: Icon(Icons.plus_one),
              tooltip: svc.i18n.labelsAdd,
              onPressed: () async {
                await vm.navigateToAddGroup();
              }),
        PopupMenuButton<int>(
          onSelected: (index) async => _onActionSelected(index, vm),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.language),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(svc.i18n.labelsLanguage),
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
                      child: Text(svc.i18n.labelsAbout),
                    )
                  ],
                ))
          ],
        ),
      ];

  Future _onActionSelected(int index, PhraseGroupGridPageVM vm) async {
    switch (index) {
      case 1:
        return vm.nextLanguage();
      case 2:
        return vm.navigateToAbout();
    }
  }
}
