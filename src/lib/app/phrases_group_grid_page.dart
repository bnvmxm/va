import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/auth_view.dart';
import 'package:vocabulary_advancer/app/common/empty.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_vm.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/app/va_app_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/services/user_service.dart';

import 'common/phrase_group_grid_card.dart';

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
            appBar: model.auth == VAAuth.unknown
                ? null
                : AppBar(
                    automaticallyImplyLeading: !kIsWeb,
                    title: Text(
                        model.authenticated
                            ? Translations.of(context).titles.Collections
                            : Translations.of(context).titles.Auth,
                        style: VATheme.of(context).textHeadline5),
                    actions: [
                      if (model.authenticated && model.anySelected)
                        IconButton(
                            icon: Icon(Icons.view_list, color: VATheme.of(context).colorTextAccent),
                            tooltip: Translations.of(context).labels.View,
                            onPressed: () => _vm.navigateToGroup()),
                      if (model.authenticated && model.anySelected)
                        IconButton(
                            icon: Icon(Icons.edit, color: VATheme.of(context).colorTextAccent),
                            tooltip: Translations.of(context).labels.Edit,
                            onPressed: () => _vm.navigateToEditor()),
                      if (model.authenticated && !model.anySelected)
                        IconButton(
                            icon: Icon(Icons.plus_one,
                                color: VATheme.of(context).colorForegroundIconUnselected),
                            tooltip: Translations.of(context).labels.Add,
                            onPressed: () => _vm.navigateToEditor()),
                      HomeMenu(_vm, authenticated: model.authenticated),
                    ],
                  ),
            body: model.authenticated
                ? model.isNotEmpty
                    ? PhraseGroupsGrid(
                        model,
                        () async {
                          _vm.load(model.auth);
                        },
                        (item) {
                          _vm.state.isSelected(item) ? _vm.unselect() : _vm.select(item);
                        },
                      )
                    : Empty()
                : model.auth == VAAuth.unknown
                    ? Center(child: CircularProgressIndicator())
                    : AuthView(
                        onSignIn: (email, passw) async => await _vm.signIn(email, passw),
                        onSignUp: (email, passw) async => await _vm.signUn(email, passw),
                        onSignInAnonymously: () async => await _vm.signAnonymously(),
                        issueUserNotFound: model.auth == VAAuth.signedOffNotFound,
                        issueEmailInUse: model.auth == VAAuth.signedOffEmailInUse,
                        issuePasswordWeak: model.auth == VAAuth.signedOffPasswordWeak),
            floatingActionButton: model.authenticated && model.anySelected
                ? FloatingActionButton(
                    tooltip: Translations.of(context).labels.Exercise,
                    backgroundColor: model.anySelectedAndNotEmpty
                        ? VATheme.of(context).colorBackgroundIconSelected
                        : VATheme.of(context).colorBackgroundIconUnselected,
                    foregroundColor: model.anySelectedAndNotEmpty
                        ? VATheme.of(context).colorForegroundIconSelected
                        : VATheme.of(context).colorForegroundIconUnselected,
                    onPressed: () => _vm.navigateToExercise(),
                    child: Icon(Icons.view_carousel))
                : null,
          ));
}

class HomeMenu extends StatelessWidget {
  final bool authenticated;
  final PhraseGroupGridViewModel _vm;
  HomeMenu(this._vm, {required this.authenticated}) : super();

  @override
  Widget build(BuildContext context) => BlocBuilder<VAAppViewModel, VAAppModel>(
      builder: (context, appModel) => PopupMenuButton<int>(
            onSelected: (index) async => _onActionSelected(context, index),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(children: [
                    Icon(Icons.language),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(Translations.of(context).labels.Language))
                  ])),
              PopupMenuItem<int>(
                  value: 2,
                  child: Row(children: [
                    Icon(appModel.themeId == VAThemeId.darkCold
                        ? Icons.dark_mode_outlined
                        : Icons.dark_mode),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(appModel.themeId == VAThemeId.darkCold
                            ? Translations.of(context).labels.LightTheme
                            : Translations.of(context).labels.DarkTheme))
                  ])),
              PopupMenuItem<int>(
                  value: 3,
                  child: Row(children: [
                    Icon(Icons.info),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(Translations.of(context).labels.About))
                  ])),
              if (authenticated)
                PopupMenuItem<int>(
                    value: 4,
                    child: Row(children: [
                      Icon(Icons.logout, color: VATheme.of(context).colorAttention),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(Translations.of(context).labels.SignOut))
                    ]))
            ],
          ));

  Future<void> _onActionSelected(BuildContext context, int index) async {
    switch (index) {
      case 1:
        return _vm.switchLanguage();
      case 2:
        BlocProvider.of<VAAppViewModel>(context).switchTheme();
        break;
      case 3:
        return _vm.navigateToAbout();
      case 4:
        await _vm.signOut();
        break;
    }
  }
}

class PhraseGroupsGrid extends StatelessWidget {
  final PhraseGroupGridModel _model;
  final Future<void> Function() onRefresh;
  final void Function(PhraseGroup) onPhraseGroupTap;

  PhraseGroupsGrid(this._model, this.onRefresh, this.onPhraseGroupTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(child: _buildGridView());

  Widget _buildGridView() => RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
          itemCount: _model.phraseGroups.length,
          itemBuilder: (context, i) => _buildGridViewTile(_model.phraseGroups[i])));

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
