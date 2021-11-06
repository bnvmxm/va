import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/about_page.dart';
import 'package:vocabulary_advancer/app/navigation/va_page.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page.dart';
import 'package:vocabulary_advancer/app/phrase_exercise_page.dart';
import 'package:vocabulary_advancer/app/phrase_list_page.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page.dart';
import 'package:vocabulary_advancer/app/phrases_group_grid_page.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class VARoute extends ChangeNotifier {
  final List<VARouteInfo> _stack = [];
  UnmodifiableListView<VARouteInfo> get stack => UnmodifiableListView<VARouteInfo>(_stack);
  VARouteInfo? get current => _stack.lastOrNull;

  final List<Function> _popResultCallbacks = [];

  void reset(Iterable<VARouteInfo> newStack) {
    _stack.clear();
    _stack.addAll(newStack);
    _popResultCallbacks.clear();
    notifyListeners();
  }

  void push(VARouteInfo info) {
    svc.log.d(() => 'PUSHING: $info onto $stack', 'VARoute');
    _stack.add(info);

    notifyListeners();
  }

  void pushForResult<T>(VARouteInfo info, Function(T) resultHandler) {
    svc.log.d(() => 'PUSHING FOR RESULT: $info onto $stack', 'VARoute');
    _stack.add(info);
    _popResultCallbacks.add(resultHandler);

    notifyListeners();
  }

  bool pop() {
    svc.log.d(() => 'POPPING FROM: $_stack', 'VARoute');
    if (_stack.isNotEmpty) {
      _stack.removeLast();
      notifyListeners();
      return true;
    }

    return false;
  }

  bool popWithResult<T>(T result) {
    svc.log.d(() => 'POPPING FROM: $_stack with $result', 'VARoute');
    assert(_stack.isNotEmpty);
    _stack.removeLast();

    assert(_popResultCallbacks.isNotEmpty);
    final resultHandler = _popResultCallbacks.removeLast(); // expecting the last if interested
    resultHandler(result);

    notifyListeners();
    return true;
  }

  @override
  String toString() => _stack.join(" -> ");
}

class VARouter extends RouterDelegate<VARouteInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<VARouteInfo> {
  VARouter(this.routeState) : navigatorKey = GlobalObjectKey<NavigatorState>(routeState) {
    routeState.addListener(_onNav);
  }

  final VARoute routeState;

  @override
  VARouteInfo? get currentConfiguration => routeState.current;

  @override
  GlobalObjectKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    svc.log.d(() => 'BUILD. Stack: $routeState', 'VARouter');
    return currentConfiguration == null
        ? CircularProgressIndicator()
        : Navigator(
            key: navigatorKey,
            pages: routeState.stack.map(_map).toList(),
            onPopPage: (route, dynamic result) {
              if (!route.didPop(result)) {
                svc.log.d(() => 'onPopPage. Rejected', 'VARouter');
                return false;
              }

              final r = routeState.pop();
              svc.log.d(() => 'onPopPage. POP = $r', 'VARouter');
              return r;
            },
          );
  }

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

  Iterable<VARouteInfo> _rebuildStackFor(VARouteInfo info) {
    if (info is VARouteRoot || svc.userService.user == null) {
      return [VARouteRoot()];
    }

    if (info is VARouteEditPhrase) {
      return [VARouteRoot(), VARouteInfo.phraseGroup(info.groupId), info];
    }

    return [VARouteRoot(), info];
  }

  @override
  Future<void> setNewRoutePath(VARouteInfo info) async {
    svc.log.d(() => 'new route state: $info, ${info.hashCode}', 'VARouter NEW ROUTE');
    routeState.reset(_rebuildStackFor(info));
  }

  void _onNav() {
    notifyListeners();
  }

  @override
  void dispose() {
    routeState.removeListener(_onNav);
    super.dispose();
  }
}
