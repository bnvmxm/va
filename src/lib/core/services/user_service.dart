import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

enum VAAuth { unknown, failed, signedOff, anonymous, signedIn }

class VAUser {
  VAUser({this.isAnonymous, this.uid, this.email});

  final bool? isAnonymous;
  final String? uid;
  final String? email;
}

class VAUserService {
  VAUser? user;
  VAAuth auth = VAAuth.unknown;
  Future get initialized => _initCompleter.future;

  final _authState = StreamController<VAAuth>();
  Stream<VAAuth> get authState => _authState.stream;

  final Completer<void> _initCompleter = Completer();

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  void init() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen(_onUserStateChanged, onError: _onUserStateFailed);
  }

  void track(String eventName, [Map<String, Object?>? parameters]) {
    _analytics.logEvent(name: eventName, parameters: parameters);
    svc.log.i(() => eventName, 'Analytics');
  }

  void _onUserStateFailed(Object? error) {
    final err = error ?? Error();
    track('auth_failed', {'error': err});

    auth = VAAuth.failed;
    if (!_initCompleter.isCompleted) {
      _initCompleter.completeError(err);
    }

    _authState.add(auth);
  }

  void _onUserStateChanged(User? u) {
    if (u == null) {
      user = null;
      auth = VAAuth.signedOff;
      track('auth_signOff');

      // clean up the user storage
    } else {
      user = VAUser(
        isAnonymous: u.isAnonymous,
        uid: u.uid,
        email: u.email,
      );

      auth = u.isAnonymous ? VAAuth.anonymous : VAAuth.signedIn;
      _analytics.setUserId(u.uid);
      track('auth_signIn', {'email': u.email});
    }

    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }

    _authState.add(auth);
  }
}
