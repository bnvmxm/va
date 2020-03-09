import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/common/phrase_group_grid.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupGridPage extends VAPage<PhraseGroupGridPageVM> {
  @override
  PhraseGroupGridPageVM createVM() => svc.vmPhraseGroupGridPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseGroupGridPageVM vm) => AppBar(
        title: Text(svc.i18n.titlesCollections),
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
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).cardColor,
          foregroundColor: vm.anySelectedAndNotEmpty
              ? Theme.of(context).floatingActionButtonTheme.foregroundColor
              : Theme.of(context).dividerColor,
          onPressed: () async {
            await vm.navigateToExercise();
          },
          child: Icon(Icons.view_carousel))
      : null;

  List<Widget> _buildAppBarActions(BuildContext context, PhraseGroupGridPageVM vm) => [
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.view_list),
              tooltip: svc.i18n.labelsView,
              onPressed: () async {
                await vm.navigateToGroup();
              }),
        if (vm.anySelected)
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: svc.i18n.labelsEdit,
              onPressed: () async {
                await vm.navigateToEditGroup();
              }),
        if (!vm.anySelected)
          IconButton(
              icon: const Icon(Icons.plus_one),
              tooltip: svc.i18n.labelsAdd,
              onPressed: () async {
                await vm.navigateToAddGroup();
              }),
        IconButton(
            icon: const Icon(Icons.info),
            tooltip: svc.i18n.labelsAbout,
            onPressed: () async {
              await vm.navigateToAbout();
            }),
        IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Language',
            onPressed: () async {
              final l10n = await svc.svcLocalization;
              if (l10n.currentLocale.languageCode == 'en') {
                l10n.setLocale(l10n.getSupportedLocales().last);
              } else {
                l10n.setLocale(l10n.getSupportedLocales().first);
              }
            })
      ];
}
