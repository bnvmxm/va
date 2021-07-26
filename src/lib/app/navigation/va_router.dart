import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page.dart';

class VARoute extends ChangeNotifier {
  static VARoute i = VARoute._();
  VARoute._();

  final List<VARouteInfo> _stack = [];
  UnmodifiableListView<VARouteInfo> get stack => UnmodifiableListView<VARouteInfo>(_stack);
  VARouteInfo? get current => _stack.lastOrNull;

  dynamic _popResult;
  dynamic get popResult => _popResult;

  void push(VARouteInfo info) {
    _stack.add(info);
    _popResult = null;
    notifyListeners();
  }

  bool pop() {
    if (_stack.length > 1) {
      _stack.removeLast();
      _popResult = null;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool popWithResult(dynamic result) {
    if (_stack.length > 1) {
      _stack.removeLast();
      _popResult = result;
      notifyListeners();
      return true;
    }

    return false;
  }
}

class VARouter extends RouterDelegate<VARouteInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<VARouteInfo> {
  VARouter() {
    _route.addListener(notifyListeners);
  }

  final _nav = GlobalKey<NavigatorState>();
  final _route = VARoute.i;

  @override
  VARouteInfo? get currentConfiguration => _route.current;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _nav;

  @override
  Widget build(BuildContext context) => Navigator(
        key: _nav,
        pages: _route.stack.map(_map).toList(),
        onPopPage: (route, dynamic result) => route.didPop(result),
      );

  VAPage _map(VARouteInfo info) {
    if (info is VARouteAbout) {
      return VAPage(info.toString(), child: AboutPage());
    }
    if (info is VARouteAddPhraseGroup) {
      return VAPage(info.toString(), child: PhraseGroupEditorPage());
    }
    if (info is VARouteEditPhraseGroup) {
      return VAPage(info.toString(), child: PhraseGroupEditorPage(info.groupId));
    }
    if (info is VARoutePhraseGroup) {
      return VAPage(info.toString(), child: PhraseListPage(info.groupId));
    }
    if (info is VARouteExercise) {
      return VAPage(info.toString(), child: PhraseExercisePage(info.groupId));
    }
    if (info is VARouteAddPhrase) {
      return VAPage(info.toString(), child: PhraseEditorPage(info.groupId));
    }
    if (info is VARouteEditPhrase) {
      return VAPage(info.toString(), child: PhraseEditorPage(info.groupId, info.phraseUid));
    }

    return VAPage(info.toString(), child: PhraseGroupGridPage());
  }

  @override
  Future<void> setNewRoutePath(VARouteInfo info) async => _route.push(info);

  @override
  void dispose() {
    _route.removeListener(notifyListeners);
    super.dispose();
  }
}
