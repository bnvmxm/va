import 'package:flutter/material.dart';

enum ViewModelState { busy, ready }

abstract class BaseViewModel<TArgument> with ChangeNotifier {
  ViewModelState _state;

  bool get isReady => _state != null && _state == ViewModelState.ready;
  bool get isBusy => _state != null && _state == ViewModelState.busy;

  void setState(ViewModelState value) {
    notify(() {
      _state = value;
    });
  }

  Future Function(TArgument argument) get initializer;

  Future initialize({TArgument argument}) async {
    notifyWhen(() => initializer(argument), asBusy: true);
  }

  void invalidate() {
    notifyListeners();
  }

  void notify(Function action, {bool asBusy = false}) {
    if (asBusy) {
      _state = ViewModelState.busy;
      notifyListeners();
    }

    action();

    _state = ViewModelState.ready;
    notifyListeners();
  }

  Future<T> notifyWhen<T>(Future<T> Function() action,
      {bool asBusy = false, bool asMicrotask = false}) async {
    if (asBusy) {
      _state = ViewModelState.busy;
      notifyListeners();
    }

    final result = asMicrotask ? await Future.microtask(action) : await action();

    _state = ViewModelState.ready;
    notifyListeners();
    return result;
  }
}
